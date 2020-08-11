# etcd

## TL;DR;

```console
helm repo add test https://charts.kubesphere.io/test
helm repo update
helm install test/etcd
```

## Installing

To install the chart with the release name `my-release`:

```console
helm repo add test https://charts.kubesphere.io/test
helm repo update
helm install --name my-release test/etcd
```

The command deploys the standalone etcd chart on the Kubernetes cluster with the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the etcd chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.etcd.repository` | The image of etcd container | `kubesphere/etcd`
`image.etcd.tag` | The tag of the etcd image | ``
`image.etcd.pullPolicy` | The pull policy of the etcd image | `IfNotPresent`
`extraArgs` | Custom configurations for etcd | `[]`
`service.port` | The service port within the pod container | `2379`
