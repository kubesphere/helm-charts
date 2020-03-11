# Ks-installer

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release experimental/ks-installer
```

The command deploys the kubesphere installer chart on the Kubernetes cluster in the default configuration. 

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v2.1.1`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`
`config.date`| The ConfigMap of the ks-installer| 