# csi-qingcloud

## TL;DR;

```console
helm install test/csi-qingcloud
```

## Installing

To install the chart with the release name `csi-qingcloud`:

```console
helm repo add test https://charts.kubesphere.io/test
helm install test/csi-qingcloud --name-template csi-qingcloud --namespace kube-system  \\ 
--set config.qy_access_key_id=key,config.qy_secret_access_key=secret,config.zone=zone,sc.enable=true,sc.type=0
```

The command deploys the `csi-qingcloud` chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `csi-qingcloud` deployment:

```console
helm delete csi-qingcloud --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the redis chart and their default values.

Parameter | Description | Default
--- | --- | ---
`config.qy_access_key_id` | Access key id of QingCloud | ``
`config.qy_secret_access_key` | Access secret of QingCloud | ``
`config.zone` | Zone of QingCloud | ``
`config.host` | API host of QingCloud | `api.qingcloud.com`
`config.port` | API port of QingCloud | `443`
`config.protocol` | API protocol of QingCloud | `https`
`config.uri` | API URI of QingCloud | `/iaas`
`config.connection_retries` | Retry count of API| `3`
`config.connection_timeout` | Retry time out of API| `30`
`driver.name` | Name of the CSI driver | `disk.csi.qingcloud.com`
`driver.repository` | Image of CSI plugin| `csiplugin/csi-qingcloud`
`driver.tag` | Tag of CSI plugin | `v1.2.0-rc3 `
`driver.pullPolicy` | Image pull policy of CSI plugin | `IfNotPresent`
`driver.maxVolume` | Max volume of CSI plugin | `10`
`provisioner.repository` | Image of csi-provisioner | `csiplugin/csi-provisioner`
`provisioner.tag` | Tag of csi-provisioner | `v1.5.0`
`provisioner.volumeNamePrefix` | Prefix of volume name created by the driver | `pvc`
`attacher.repository` | Image of csi-attacher | `csiplugin/csi-attacher`
`attacher.tag` | Tag of csi-attacher | `v2.1.1`
`resizer.repository` | Image of csi-resizer | `csiplugin/csi-resizer`
`resizere.tag` | Tag of csi-resizer | `v0.4.0`
`snapshotter.repository` | Image of csi-snapshotter | `csiplugin/csi-snapshotter`
`snapshotter.tag` | Tag of csi-snapshotter | `v2.0.1`
`registar.repository` | Image of csi-node-driver-registrar| `csiplugin/csi-node-driver-registrar`
`registar.tag` | Tag of csi-node-driver-registrar | `v1.2.0`
`sc.enable` | If storage class installed | `false`
`sc.name` | Name of storage class | `csi-qingcloud`
`sc.type` | Type parameter of storage class | `0`
`sc.tags` | Tag parameter of storage class | ``
`sc.fsType` | FsType parameter of storage class | `ext4`

