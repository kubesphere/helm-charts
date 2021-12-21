# pvc-autoresizer Helm Chart

## How to use pvc-autoresizer Helm repository

You need to add this repository to your Helm repositories:

```sh
helm repo add main https://charts.kubesphere.io/main
helm repo update
```

## Quick start

### Installing the Chart

To install the chart with the release name `pvc-autoresizer` using a dedicated namespace(recommended):

```sh
helm install --create-namespace --namespace pvc-autoresizer pvc-autoresizer main/pvc-autoresizer
```

Specify parameters using `--set key=value[,key=value]` argument to `helm install`.

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```sh
helm upgrade --create-namespace --namespace pvc-autoresizer -i pvc-autoresizer -f values.yaml pvc-autoresizer/pvc-autoresizer
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.args.additionalArgs | list | `[]` | Specify additional args. |
| controller.args.interval | string | `"10s"` | Specify interval to monitor pvc capacity. Used as "--interval" option |
| controller.args.prometheusURL | string | `"http://prometheus-prometheus-oper-prometheus.prometheus.svc:9090"` | Specify Prometheus URL to query volume stats. Used as "--prometheus-url" option |
| controller.nodeSelector | object | `{}` | Map of key-value pairs for scheduling pods on specific nodes. |
| controller.replicas | int | `1` | Specify the number of replicas of the controller Pod. |
| controller.resources | object | `{"requests":{"cpu":"100m","memory":"20Mi"}}` | Specify resources. |
| controller.terminationGracePeriodSeconds | string | `nil` | Specify terminationGracePeriodSeconds. |
| controller.tolerations | object | `{}` | Ensure pods are not scheduled on inappropriate nodes. |
| image.pullPolicy | string | `nil` | pvc-autoresizer image pullPolicy. |
| image.repository | string | `"f10atin9/pvc-autoresizer` | pvc-autoresizer image repository to use. |
| image.tag | string | `{{ .Chart.AppVersion }}` | pvc-autoresizer image tag to use. |

## Generate Manifests

You can use the `helm template` command to render manifests.

```sh
helm template --namespace pvc-autoresizer pvc-autoresizer main/pvc-autoresizer
```
