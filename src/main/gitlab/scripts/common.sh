#!/bin/bash

# Checks that appropriate gke params are set and
# that gcloud and kubectl are properly installed and authenticated
function need_tool(){
  local tool="${1}"
  local url="${2}"

  echo >&2 "${tool} is required. Please follow ${url}"
  exit 1
}

function need_gcloud(){
  need_tool "gcloud" "https://cloud.google.com/sdk/downloads"
}

function need_kubectl(){
  need_tool "kubectl" "https://kubernetes.io/docs/tasks/tools/install-kubectl"
}

function need_helm(){
  need_tool "helm" "https://github.com/helm/helm/#install"
}

function need_eksctl(){
  need_tool "eksctl" "https://eksctl.io"
}

function validate_tools(){
  for tool in "$@"
  do
    # Basic check for installation
    command -v "${tool}" > /dev/null 2>&1 || "need_${tool}"

    # Additional  checks if validating gcloud binary
    if [ "$tool" == 'gcloud' ]; then
      if [ -z "$PROJECT" ]; then
        echo "\$PROJECT needs to be set to your project id";
        exit 1;
      fi

      gcloud container clusters list --project $PROJECT >/dev/null 2>&1 || { echo >&2 "Gcloud seems to be configured incorrectly or authentication is unsuccessfull"; exit 1; }
    fi
  done
}

function check_helm_3(){
  set +e
  helm version --short --client | grep -q '^v3\.[0-9]\{1,\}'
  IS_HELM_3=$?
  set -e

  echo $IS_HELM_3
}

function set_helm_name_flag(){

  IS_HELM_3=$(check_helm_3)

  if [[ "$IS_HELM_3" -eq "0" ]]; then
    name_flag=''
  else
    name_flag='--name'
  fi

  echo $name_flag
}

function set_helm_purge_flag(){

  IS_HELM_3=$(check_helm_3)

  if [[ "$IS_HELM_3" -eq "0" ]]; then
    purge_flag=''
  else
    purge_flag='--purge'
  fi

  echo $purge_flag
}

function cluster_admin_password_gke(){
  gcloud container clusters describe $CLUSTER_NAME --zone $ZONE --project $PROJECT --format='value(masterAuth.password)';
}
