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
  need_tool "helm" "https://github.com/kubernetes/helm/blob/master/docs/install.md"
}

function need_eksctl(){
  need_tool "eksctl" "https://exkctl.io"
}

function validate_required_tools(){
  if [ -z "$PROJECT" ]; then
    echo "\$PROJECT needs to be set to your project id";
    exit 1;
  fi

  for comm in gcloud kubectl helm
  do
    command  -v "${comm}" > /dev/null 2>&1 || "need_${comm}"
  done

  gcloud container clusters list >/dev/null 2>&1 || { echo >&2 "Gcloud seems to be configured incorrectly or authentication is unsuccessfull"; exit 1; }

}

function cluster_admin_password_gke(){
  gcloud container clusters describe $CLUSTER_NAME --zone $ZONE --project $PROJECT --format='value(masterAuth.password)';
}

function validate_eks_required_tools(){
  for comm in eksctl kubectl helm
  do
    command -v "${comm}" > /dev/null 2>&1 || "need_${comm}"
  done
}
