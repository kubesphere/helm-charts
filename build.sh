#!/usr/bin/env bash

set -e

ensureVars() {
  echo "Checking required variables ..."
  for var in $@; do
    if [ -z "${!var}" ]; then
      echo "Environment variable '$var' should be defined." && exit 1
    fi
  done
}

helm() {
  ./helm $@
}

helmVersion=v2.12.3
prepareHelm() {
  local helmUrl=https://storage.googleapis.com/kubernetes-helm/helm-$helmVersion-linux-amd64.tar.gz
  echo "Downloading Helm Client from '$helmUrl' ..."
  curl -sL $helmUrl | tar --strip-components=1 -xzf - linux-amd64/helm
  helm init --client-only
}

findUpdatedCharts() {
  local repoDir=$1 indexFile=$2
  local existingCharts="$(grep -oE "[^/]+\.tgz$" $indexFile)"
  local srcFiles="$(ls $repoDir/*/Chart.yaml)"
  for srcFile in $srcFiles; do
    local chartName=$(awk '/^name:/ {name=$2} /^version:/ {version=$2} END {printf "%s-%s.tgz", name, version}' $srcFile)
    echo $existingCharts | grep -q $chartName || echo $(dirname $srcFile)
  done
}

reposCount=0
generateRepoName() {
  reposCount=$((reposCount+1))
  echo -n "repo-$reposCount"
}

addDependencyRepos() {
  local knownRepos="$(helm repo list | awk 'NR>1 {print $2}')"
  for chartDir in $@; do
    local reqFile="$chartDir/requirements.yaml"
    if [ -f "$reqFile" ]; then
      local repoUrls="$(awk '$1=="repository:" {print $2}' $reqFile | uniq)"
      [ -z "$repoUrls" ] || for repoUrl in $repoUrls; do
        echo $knownRepos | grep -q ${repoUrl%/} || helm repo add $(generateRepoName) ${repoUrl%/}
      done
    fi
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

  echo Linting charts [$updatedCharts] ...
  helm lint $updatedCharts

  echo Adding dependency repos for [$updatedCharts] ...
  addDependencyRepos $updatedCharts

  echo Packaging charts [$updatedCharts] ...
  helm package $updatedCharts --destination $repoDir -u

  local mergeOpts
  [ -f "$indexFile" ] && mergeOpts="--merge $indexFile"
  helm repo index $repoDir --url $repoUrl $mergeOpts

  updatedRepos="$repo:$updatedRepos"
}

updateRepos() {
  ensureVars BASE_URL
  echo "Updating Helm repos ..."
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
  git fetch
  git checkout --track origin/gh-pages
  for repo in $(ls $buildDir); do
    mkdir -p $repo && mv $buildDir/$repo/* $repo/ && git add $repo
  done
  git commit -m "Update Charts"
  injectGithubToken
  echo "Pushing updates to GitHub ..."
  git push origin HEAD:gh-pages
}

prepareHelm
updateRepos
[ -z "$updatedRepos" ] || [ "$1" != "deploy" ] || pushUpdates

