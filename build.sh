#!/usr/bin/env bash

set -e

ensureVars() {
  echo "Checking required variables ..."
  local var
  for var in $@; do
    if [ -z "${!var}" ]; then
      echo "Environment variable '$var' should be defined." && exit 1
    fi
  done
}

helm() {
  ./helm $@
}

helmVersion=3.2.4
prepareHelm() {
  local helmUrl=https://get.helm.sh/helm-v$helmVersion-linux-amd64.tar.gz
  echo "Downloading Helm Client from '$helmUrl' ..."
  curl -sL $helmUrl | tar --strip-components=1 -xzf - linux-amd64/helm
}

findUpdatedCharts() {
  local repoDir=$1 indexFile=$2
  local existingCharts="$(grep -oE "[^/]+\.tgz$" $indexFile)"
  local srcFiles="$(ls $repoDir/*/Chart.yaml)" srcFile
  for srcFile in $srcFiles; do
    local chartName=$(awk '/^name:/ {name=$2} /^version:/ {version=$2} END {printf "%s-%s.tgz", name, version}' $srcFile)
    echo $existingCharts | grep -q $chartName || echo $(dirname $srcFile)
  done
}

addDependencyRepos() {
  local knownRepos="$(helm repo list | awk 'NR>1 {print $2}')" chartDir
  for chartDir in $@; do
    local reqFile="$chartDir/requirements.yaml"
    if [ -f "$reqFile" ]; then
      local depRepos="$(awk '$1=="repository:" {print $2}' $reqFile | uniq)" depRepo
      [ -z "$depRepos" ] || for depRepo in $depRepos; do
        depRepo=${depRepo%/}
        echo $knownRepos | grep -q $depRepo || helm repo add ${depRepo//[.:\/]/-} $depRepo
      done
    fi
  done
}

updateDependencies() {
  for chartDir in $@; do
    helm dependency update $chartDir
  done
}

srcDir=src
buildDir=build
mkdir -p $buildDir
updatedRepos=
updateRepo() {
  local repo=$1 repoUrl repoDir indexFile httpCode updatedCharts
  repoUrl=$BASE_URL/$repo
  indexUrl=$repoUrl/index.yaml

  repoSrcDir=$srcDir/$repo
  repoDir=$buildDir/$repo
  indexFile=$repoDir/index.yaml

  echo "Updating repo [repo=$repo repoUrl=$repoUrl indexUrl=$indexUrl srcDir=$repoSrcDir repoDir=$repoDir indexFile=$indexFile] ..."
  mkdir -p $repoDir

  echo "Downloading current Helm index '$indexUrl' ..."
  httpCode=$(curl -s -m 5 -o $indexFile -w '%{http_code}' "$indexUrl") || {
    echo "Failed to download current Helm index '$indexUrl' ($?)."
    return 1
  }

  [[ "$httpCode" =~ ^200|404$ ]] || {
    echo "Error occurred when fetching '$repoUrl': code=$httpCode content=$(cat $indexFile)."
    return 1
  }

  [ "$httpCode" = "404" ] && rm -f $indexFile

  echo "Finding updated charts ..."
  updatedCharts="$(findUpdatedCharts $repoSrcDir $indexFile)"
  updatedCharts="$(echo $updatedCharts)"
  if [ -z "$updatedCharts" ]; then
    echo "No charts added or updated in repo '$repo'."
    return 0
  fi

  echo Adding dependency repos for [$updatedCharts] ...
  addDependencyRepos $updatedCharts
  
  echo Updating dependencies for [$updateCharts] ...
  updateDependencies $updatedCharts

  echo Linting charts [$updatedCharts] ...
  helm lint $updatedCharts

  echo Packaging charts [$updatedCharts] ...
  helm package $updatedCharts --destination $repoDir -u

  local mergeOpts
  [ -f "$indexFile" ] && mergeOpts="--merge $indexFile"
  echo Generating $repo/index.yaml ...
  helm repo index $repoDir --url $repoUrl $mergeOpts

  updatedRepos="$repo:$updatedRepos"
}

updateRepos() {
  ensureVars BASE_URL
  echo "Updating Helm repos ..."
  local repo
  for repo in $(ls $srcDir); do
    [ -f "$srcDir/$repo" ] || updateRepo $repo
  done
}

injectGithubToken() {
  local url
  url=$(git remote -v | awk '$3=="(push)" {print $2}' | sed -E "s|^https://[^/]*(.+)$|https://$GITHUB_USER:$GITHUB_TOKEN@github.com\1|")
  echo "Injecting GitHub token ..."
  git remote set-url origin $url
}

pushUpdates() {
  ensureVars GITHUB_USER GITHUB_TOKEN
  git commit -m "Update" --author="KubeSphere CI Bot <ks-ci-bot@users.noreply.github.com>"
  injectGithubToken
  echo "Pushing updates to GitHub ..."
  git push origin HEAD:gh-pages
}

verify() {
  prepareHelm
  updateRepos
}

deploy() {
  verify

  [ -z "$updatedRepos" ] || {
    git fetch
    git checkout --track origin/gh-pages
    local repo
    for repo in $(ls $buildDir); do
      mkdir -p $repo && mv $buildDir/$repo/* $repo/ && git add $repo
    done
    pushUpdates
  }
}

mirror() {
  local original=https://kubernetes-charts.storage.googleapis.com
  local mirrored=https://helm-chart-repo.pek3a.qingstor.com/kubernetes-charts
  git fetch
  git checkout --track origin/gh-pages
  mkdir -p mirror
  cd mirror
  curl -L $original/index.yaml -o index.yaml
  sed -i "s#$original#$mirrored#g" index.yaml
  git add index.yaml

  pushUpdates
}

$@
