# Databend Meta Helm Chart

## Prerequisites

- Kubernetes 1.14+
- Helm v3+

## Install

To install the chart with release name `my-release`:
```
helm repo add databend https://charts.databend.rs
helm install my-release databend/databend-meta --namespace databend --create-namespace
```

Note that for a production cluster, you will likely want to override the following parameters in [values.yaml](values.yaml) with your own values.

- `resources.requests.memory` and `resources.limit.memory` allocate memory resource to query pods in your cluser.
- `replicaCount` defaults to `1`, We strongly recommend that you set to `3` for HA.
- `persistence.size` defaults to `10Gi` of disk space per pod, which you may increase or decrease for your use case.
- `persistence.storageClass` uses the default storage class for your environment.

## Uninstall

To uninstall/delete a Helm release `my-release`:
```
helm delete my-release --namespace databend
```
