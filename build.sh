#!/usr/bin/env bash

set -e

mkdir -p build
repoUrl=${REPO_URL:-https://charts.kubesphere.io}
echo "Downloading Helm Client ..."
curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz | tar --strip-components=1 -xzf - linux-amd64/helm
echo "Downloading current Helm index ..."
curl -sL $repoUrl/qingcloud/index.yaml -o build/index.yaml
findNewCharts() {
  local existingCharts="$(grep -oE "[^/]+\.tgz$" build/index.yaml)"
  local srcFiles="$(ls charts/*/Chart.yaml)"
  for srcFile in $srcFiles; do
    local chartName=$(awk '/^name:/ {name=$2} /^version:/ {version=$2} END {printf "%s-%s.tgz", name, version}' $srcFile)
    echo $existingCharts | grep -q $chartName || {
      echo $(dirname $srcFile)
    }
  done
}

echo "Checking new charts ..."
newCharts="$(findNewCharts)"
[ -z "$newCharts" ] && {
  echo "No new charts found. Exiting ..."
  exit
}

./helm init --client-only
echo Packaging charts [$newCharts] ...
./helm package $(echo $newCharts) --destination build
./helm repo index build --merge build/index.yaml --url $repoUrl

git checkout --track origin/gh-pages
mv build/* qingcloud/
git add qingcloud/
git commit -m "Update Charts"
git remote set-url origin https://ks-ci-bot:$GITHUB_TOKEN@github.com/kubesphere/helm-charts.git
git push origin HEAD:gh-pages
