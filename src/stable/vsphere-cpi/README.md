# vSphere-CPI

Warning: V1.x.x introductes a new hierarchy of config to make usage as a subchart easier.
Basically all config items under `config`moved under `global.config`
## TL;DR

```console
$ helm repo add vsphere-tmm https://vsphere-tmm.github.io/helm-charts
$ helm install my-release vsphere-tmm/vsphere-cpi
```

## Introduction

This chart deploys all components required to run the external vSphere CPI as described on it's GitHub page.
https://github.com/kubernetes/cloud-provider-vsphere

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0


## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release vsphere-tmm/vsphere-cpi
```

The command deploys vSphere-CPI on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

See https://github.com/bitnami-labs/readmenator to create the table

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set config.vcenter.myvcenter.server=1.2.3.4 \
  --set config.vcenter.myvcenter.user=dummy \
  --set config.vcenter.myvcenter.password=credentials \
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml vsphere-tmm/vsphere-cpi
```

> **Tip**: You can use the default [values.yaml](values.yaml) as a guide

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
vSphere-CPI:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as vSphere-CPI (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/vSphere-CPI/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [vsphere-tmm/common](https://github.com/vsphere-tmm/charts/tree/master/vsphere-tmm/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
