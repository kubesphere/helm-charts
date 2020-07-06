# csi-neonsan 

## TL;DR;

```console
helm install test/csi-neonsan
```

## Installing

To install the chart with the release name `csi-neonsan`:

```console
helm repo add test https://charts.kubesphere.io/test
helm install test/csi-neonsan --name-template csi-neonsan --namespace kube-system
```

The command deploys the csi-neonsan chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `csi-neonsan` deployment:

```console
helm delete csi-neonsan --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the redis chart and their default values.

Parameter | Description | Default
--- | --- | ---
`driver.name` | Name of the CSI driver | `neonsan.csi.qingstor.com`
`driver.repository` | Image of CSI plugin| `csiplugin/csi-neonsan`
`driver.tag` | Tag of CSI plugin | `v1.2.0-rc1 `
`driver.pullPolicy` | Image pull policy of CSI plugin | `IfNotPresent`
`driver.config.path` | Config path of NeonSAN | `/etc/neonsan`
`driver.config.file` | Config file name of NeonSAN | `qbd.conf`
`provisioner.repository` | Image of csi-provisioner | `csiplugin/k8scsi/csi-provisioner`
`provisioner.tag` | Tag of csi-provisioner | `v1.5.0`
`provisioner.volumeNamePrefix` | Prefix of volume name created by the driver | `pvc`
`attacher.repository` | Image of csi-attacher | `csiplugin/k8scsi/csi-attacher`
`attacher.tag` | Tag of csi-attacher | `v2.1.1`
`resizer.repository` | Image of csi-resizer | `csiplugin/k8scsi/csi-resizer`
`resizere.tag` | Tag of csi-resizer | `v0.4.0`
`snapshotter.repository` | Image of csi-snapshotter | `csiplugin/csi-snapshotter`
`snapshotter.tag` | Tag of csi-snapshotter | `v2.0.1`
`registar.repository` | Image of csi-node-driver-registrar| `csiplugin/csi-node-driver-registrar`
`registar.tag` | Tag of csi-node-driver-registrar | `v1.2.0`

