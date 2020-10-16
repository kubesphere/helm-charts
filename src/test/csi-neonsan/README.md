# csi-neonsan 

## TL;DR;

```console
helm install test/csi-neonsan
```

## Prerequisite
- **qbd** installed on each node
- **qbd** modules (**qbd**&**qbd_tcp**&**qbd_rdma**) loaded


## Installing

To install the chart with the release name `csi-neonsan`:

```console
helm repo add test https://charts.kubesphere.io/test
helm install test/csi-neonsan --name-template csi-neonsan --namespace kube-system
```

The command deploys the csi-neonsan chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

If node os is **centos**, `driver.node.repository`(default `csiplugin/csi-neonsan-ubuntu`) should be set `csiplugin/csi-neonsan-centos`
```bash
helm install test/csi-neonsan --name-template csi-neonsan --namespace kube-system --set driver.node.repository=csiplugin/csi-neonsan-centos
```

## Uninstalling

To uninstall/delete the `csi-neonsan` deployment:

```console
helm delete csi-neonsan --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the csi-neonsan chart and their default values.

Parameter | Description | Default
--- | --- | ---
`driver.name` | Name of the CSI driver | `neonsan.csi.qingstor.com`
`driver.repository` | Image of CSI plugin| `csiplugin/csi-neonsan`
`driver.tag` | Tag of CSI plugin | `v1.2.0`
`driver.pullPolicy` | Image pull policy of CSI plugin | `IfNotPresent`
`driver.config` | Config of NeonSAN | `/etc/neonsan/qbd.conf`
`driver.node.repository` | Image of node DaemonSet| `csiplugin/csi-neonsan-ubuntu`
`driver.node.tag` | Tag of node DaemonSet | `v1.2.0`
`driver.node.pullPolicy` | Config file name of NeonSAN | `qbd.conf`
`provisioner.repository` | Image of csi-provisioner | `csiplugin/k8scsi/csi-provisioner`
`provisioner.tag` | Tag of csi-provisioner | `v1.5.0`
`provisioner.volumeNamePrefix` | Prefix of volume name created by the driver | `pvc`
`attacher.repository` | Image of csi-attacher | `csiplugin/k8scsi/csi-attacher`
`attacher.tag` | Tag of csi-attacher | `v2.1.1`
`resizer.repository` | Image of csi-resizer | `csiplugin/k8scsi/csi-resizer`
`resizere.tag` | Tag of csi-resizer | `v0.5.1`
`snapshotter.repository` | Image of csi-snapshotter | `csiplugin/csi-snapshotter`
`snapshotter.tag` | Tag of csi-snapshotter | `v2.0.1`
`registar.repository` | Image of csi-node-driver-registrar| `csiplugin/csi-node-driver-registrar`
`registar.tag` | Tag of csi-node-driver-registrar | `v1.2.0`
`sc.enable` | Whether to enable this StorageClass | `true`
`sc.isDefaultClass` | Whether to set this StorageClass as the default StorageClass | `false`
`sc.name` | Name of storage class | `csi-neonsan`
`sc.reclaimPolicy` | ReclaimPolicy parameter of storage class | `Delete`
`sc.allowVolumeExpansion` | AllowVolumeExpansion parameter of storage class | `true`
`sc.volumeBindingMode` | [VolumeBindingMode](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#topology-awareness) parameter of storage class | `WaitForFirstConsumer`
`sc.fsType` | [FsType](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#fstype) parameter of storage class | `ext4`

The following table lists the parameters of NeonSAN api in StorageClass's parameter. See NeonSAN api document for detail.

Parameter | Type | Default
--- | --- | ---
`sc.pool_name`| string | `kube`
`sc.rep_count`| int| `1`
`sc.mrip` | string |
`sc.mrport` | int |  
`sc.rpo` | int | 
`sc.encrypte` | string |  
`sc.key_name` | string | 
`sc.rg` | string | 
`sc.label` | string | 
`sc.policy` | string| 
`sc.dc` | string
`sc.sample_volume` | string| 
`sc.mutex_group` | string | 
`sc.role` | string | 
`sc.min_rep_count` | int| 
`sc.max_bs` | int | 

