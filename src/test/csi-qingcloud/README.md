# csi-qingcloud

## TL;DR;

```console
helm install test/csi-qingcloud
```

## Installing

To install the chart with the release name `csi-qingcloud`:

```console
helm repo add test https://charts.kubesphere.io/test
helm install test/csi-qingcloud --name-template csi-qingcloud --namespace kube-system  \
--set config.qy_access_key_id=key,config.qy_secret_access_key=secret,config.zone=zone
```

The command deploys the `csi-qingcloud` chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `csi-qingcloud` deployment:

```console
helm delete csi-qingcloud --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrade Notes
The qingcloud-csi chart uses csi-snapshotter v4.0.0 by default starting from chart v1.2.9, v1 snapshot CRDs are required for csi-snapshotter v4.0.0 and above, therefore user must install v1 snapshot CRDs prior to the upgrade, otherwise the snapshot operation will fail.
csi-snapshotter v4.0.0 supports both v1 and v1beta1 snapshot objects.
User can specify chart value `snapshotter.tag=v2.0.1` with helm to use csi-snapshotter v2.0.1 which does not require v1 snapshot CRDs to be installed.

## Support matrix　

Chart Version | Snapshot CRDs Version | Min K8s Version 
--- | --- | --- 
 &lt;= 1.2.8 | only v1beta1 | 1.14 
 &gt;= 1.2.9 | both v1beta1 and v1, only v1 | 1.17 

## Vertical Pod Autoscaler
Vertical Pod Autoscaler (VPA) frees the users from necessity of setting up-to-date resource limits and requests for the containers in their pods.

- Set `enableVPA` to `true` in ` values.yaml ` to apply VerticalPodAutoscaler for csi-qingcloud-controller. (Need to make sure that [vertical-pod-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) can work first.)

- Specify the `minAllowed` and `maxAllowed` value for each container in `values.yaml`, if the defaults don't meet your need.

- When setting limits VPA will conform to resource policies. It will maintain limit to request ratio specified for all containers. VPA will try to cap recommendations between min and max of limit ranges. If limit range conflicts and VPA resource policy conflict then VPA will follow **VPA policy** (and set values outside limit range).
  For details, refer to the following [examples](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#examples)


- By default, VPA won't update the resource requests/limits of the container if the replicas is 1, in this case, the csi-qingcloud-controller, you can enforce this by adding below arguments to the vpa-updater deployment:
```yaml
  args:
    - "--min-replicas=1"
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

Parameter | Description | Default
--- | --- | ---
`config.qy_access_key_id` | Access key id of QingCloud | 
`config.qy_secret_access_key` | Access secret of QingCloud | 
`config.zone` | Zone of QingCloud | 
`config.host` | API host of QingCloud | `api.qingcloud.com`
`config.port` | API port of QingCloud | `443`
`config.protocol` | API protocol of QingCloud | `https`
`config.uri` | API URI of QingCloud | `/iaas`
`config.connection_retries` | Retry count of API| `3`
`config.connection_timeout` | Retry time out of API| `30`
`driver.name` | Name of the CSI driver | `disk.csi.qingcloud.com`
`driver.repository` | Image of CSI plugin| `csiplugin/csi-qingcloud`
`driver.pullPolicy` | Image pull policy of CSI plugin | `IfNotPresent`
`driver.maxVolume` | Max volume of CSI plugin | `9`
`driver.retryDetachTimesMax` | Max time of retry detach | `100`
`driver.kubeletDir` | Directory of kubelet | `/var/lib/kubelet`
`provisioner.repository` | Image of csi-provisioner | `csiplugin/csi-provisioner`
`provisioner.tag` | Tag of csi-provisioner | `v2.2.2`
`provisioner.volumeNamePrefix` | Prefix of volume name created by the driver | `pvc`
`attacher.repository` | Image of csi-attacher | `csiplugin/csi-attacher`
`attacher.tag` | Tag of csi-attacher | `v3.2.1`
`resizer.repository` | Image of csi-resizer | `csiplugin/csi-resizer`
`resizere.tag` | Tag of csi-resizer | `v1.2.0`
`snapshotter.repository` | Image of csi-snapshotter | `csiplugin/csi-snapshotter`
`snapshotter.tag` | Tag of csi-snapshotter | `v4.0.0`
`registar.repository` | Image of csi-node-driver-registrar| `csiplugin/csi-node-driver-registrar`
`registar.tag` | Tag of csi-node-driver-registrar | `v2.2.0`
`sc.enable` | Whether to enable this StorageClass | `true`
`sc.isDefaultClass` | Whether to set this StorageClass as the default StorageClass | `false`
`sc.name` | Name of storage class | `csi-qingcloud`
`sc.type` | [Type](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#type-maxsize-minsize-stepsize) parameter of storage class. If set`auto`, disk type will be automatically set according to instance type| `auto`
`sc.replica` | `1` represents single duplication disk，`2` represents multiple duplication disk | 2
`sc.tags` | [Tag](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#tags) parameter of storage class | 
`sc.fsType` | [FsType](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#fstype) parameter of storage class | `ext4`
`sc.reclaimPolicy` | ReclaimPolicy parameter of storage class | `Delete`
`sc.allowVolumeExpansion` | AllowVolumeExpansion parameter of storage class | `true`
`sc.volumeBindingMode` | [VolumeBindingMode](https://github.com/yunify/qingcloud-csi/blob/master/docs/user-guide.md#topology-awareness) parameter of storage class | `WaitForFirstConsumer`
`enableVPA` | Whether to enable [vertical-pod-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) | `false`
