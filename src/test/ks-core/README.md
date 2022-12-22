# KubeSphere Helm Chart

## Introduction

[KubeSphere](https://kubesphere.io/) is a distributed operating system managing cloud native applications with
Kubernetes as its kernel, and provides plug-and-play architecture for the seamless integration of third-party
applications to boost its ecosystem.

The helm chart of ks-core, supports installing KubeSphere core on existing Kubernetes.

## Prerequisites

- Kubernetes v1.20.x、v1.21.x、v1.22.x、v1.23.x
- Helm3

## Installing

Check out configuration in `values.yaml` and install the chart with the release name `my-release`:

```console
helm install --name my-release ks-core --namespace=kubesphere-system --create-namespace
```

The command deploys the kubesphere installer chart on the Kubernetes cluster.

## Uninstalling

show ks-core chart

```console
helm list 
```

To uninstall/delete all charts related to ks-core:

```console
helm delete my-release
```

The command removes ks-core with the chart and deletes the release.

## Parameters

### Global Parameters

| Parameter                 | Description                                     | Value                              |
|---------------------------|-------------------------------------------------|------------------------------------|
| `global.imageRegistry`    | Global Docker image registry                    | `registry.cn-beijing.aliyuncs.com` |
| `global.tag`              | Global Docker image tag                         | `ksc`                              |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`                               |

### KSE Parameters

### ks-apiserver Parameters

| Parameter                     | Description                                                                                                  | Value              |
|-------------------------------|--------------------------------------------------------------------------------------------------------------|--------------------|
| `apiserver.image.registry`    | ks-apiserver image registry                                                                                  | `""`               |
| `apiserver.image.repositroy`  | ks-apiserver image registry                                                                                  | `kse/ks-apiserver` |
| `apiserver.image.tag`         | ks-apiserver image tag                                                                                       | `""`               |
| `apiserver.image.digest`      | ks-apiserver image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`               |
| `apiserver.image.pullPolicy`  | ks-apiserver image pull policy                                                                               | `IfNotPreset`      |
| `apiserver.image.pullSecrets` | ks-apiserver image pull secrets                                                                              | `[]`               |
| `apiserver.replicaCount`      | ks-apiserver replica count                                                                                   | `1`                |
| `apiserver.resources.limit`   | ks-apiserver resource limit                                                                                  | `{}`               |
| `apiserver.resources.request` | ks-apiserver resource request                                                                                | `{}`               |
| `apiserver.command`           | Override default container command (useful when using custom images)                                         | `{}`               |
| `apiserver.containerPort`     | List of container ports to enable in the ks-apiserver                                                        | `[]`               |
| `apiserver.extraEnvs`         | Additional environment variables to set for ks-apiserver                                                     | `[]`               |
| `apiserver.extraVolumes`      | Optionally specify extra list of additional volumes for the ks-apiserver pod(s)                              | `[]`               |
| `apiserver.extraVolumeMounts` | Optionally specify extra list of additional volumeMounts for the ks-apiserver container(s)                   | `[]`               |

### ks-console Parameters

| Parameter                   | Description                                                                                             | Value         |
|-----------------------------|---------------------------------------------------------------------------------------------------------|---------------|
| `console.image.registry`    | console image registry                                                                                  | `""`          |
| `console.image.repositroy`  | console image registry                                                                                  | `kse/console` |
| `console.image.tag`         | console image tag                                                                                       | `""`          |
| `console.image.digest`      | console image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`          |
| `console.image.pullPolicy`  | console image pull policy                                                                               | `IfNotPreset` |
| `console.image.pullSecrets` | console image pull secrets                                                                              | `[]`          |
| `console.replicaCount`      | ks-console replica count                                                                                | `1`           |
| `console.resources.limit`   | ks-console resource limit                                                                               | `{}`          |
| `console.resources.request` | ks-console resource request                                                                             | `{}`          |
| `console.command`           | Override default container command (useful when using custom images)                                    | `{}`          |
| `console.containerPort`     | List of container ports to enable in the ks-console                                                     | `[]`          |
| `console.extraEnvs`         | Additional environment variables to set for ks-console                                                  | `[]`          |
| `console.extraVolumes`      | Optionally specify extra list of additional volumes for the ks-console pod(s)                           | `[]`          |
| `console.extraVolumeMounts` | Optionally specify extra list of additional volumeMounts for the ks-console container(s)                | `[]`          |

### ks-controller-manager Parameters
| Parameter                      | Description                                                                                                | Value            |
|--------------------------------|------------------------------------------------------------------------------------------------------------|------------------|
| `controller.image.registry`    | controller image registry                                                                                  | `""`             |
| `controller.image.repositroy`  | controller image registry                                                                                  | `kse/controller` |
| `controller.image.tag`         | controller image tag                                                                                       | `""`             |
| `controller.image.digest`      | controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`             |
| `controller.image.pullPolicy`  | controller image pull policy                                                                               | `IfNotPreset`    |
| `controller.image.pullSecrets` | controller image pull secrets                                                                              | `[]`             |
| `controller.replicaCount`      | controller replica count                                                                                   | `1`              |
| `controller.resources.limit`   | controller resource limit                                                                                  | `{}`             |
| `controller.resources.request` | controller resource request                                                                                | `{}`             |
| `controller.command`           | Override default container command (useful when using custom images)                                       | `{}`             |
| `controller.containerPort`     | List of container ports to enable in the controller                                                        | `[]`             |
| `controller.extraEnvs`         | Additional environment variables to set for controller                                                     | `[]`             |
| `controller.extraVolumes`      | Optionally specify extra list of additional volumes for the controller pod(s)                              | `[]`             |
| `controller.extraVolumeMounts` | Optionally specify extra list of additional volumeMounts for the controller container(s)                   | `[]`             |

### Other Parameters
| Parameter                      | Description                                                                                                | Value            |
|--------------------------------|------------------------------------------------------------------------------------------------------------|------------------|
| `adminPassword`                | The admin user password                                                                                    | `"P@88w0rd"`     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release ks-core --set image.ks_apiserver_repo=kubespheredev/ks-apiserver
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the
chart. For example:

```console
$ helm install my-release ks-core -f values.yaml
```
