#!/bin/bash

is_semver() {
  if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    return 0
  else
    return 1
  fi
}

CNG_REGISTRY=${CNG_REGISTRY:-"registry.gitlab.com/gitlab-org/build/cng"}

GITLAB_VERSION=$(awk '/^appVersion:/ {print $2}' Chart.yaml)
if [ "${GITLAB_VERSION}" == "master" ]; then
  echo "Chart specifies master as GitLab version. Hence not waiting for images."
  exit 0
elif is_semver "${GITLAB_VERSION}"; then
  # if it's semver, we are using a releasable tag, and that tag will have a v prepended
  wait_on_version="v${GITLAB_VERSION}"
else
  # if it's not semver, no v will be prepended
  wait_on_version=${GITLAB_VERSION}
fi

#TODO: Get all the components and their corresponding versions
components=(gitlab-rails-ee gitlab-webservice-ee gitlab-workhorse-ee gitlab-sidekiq-ee gitlab-task-runner-ee)

for component in "${components[@]}"; do
  image="${CNG_REGISTRY}/${component}:${wait_on_version}"
  echo -n "Waiting for ${image}: "
  while ! $(DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect "${image}" > /dev/null 2>&1 ) ; do
    echo -n ".";
    sleep 1m;
  done
  echo "Found"
done
