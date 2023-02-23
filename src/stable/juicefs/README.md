# juicefs-csi-driver

![Version: 0.14.1](https://img.shields.io/badge/Version-0.14.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.18.0](https://img.shields.io/badge/AppVersion-0.18.0-informational?style=flat-square)

A Helm chart for JuiceFS CSI Driver

**Homepage:** <https://github.com/juicedata/juicefs-csi-driver>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Juicedata Inc. | <team@juicedata.io> | <https://juicefs.com> |

## Source Code

* <https://github.com/juicedata/juicefs-csi-driver>

## Requirements

Kubernetes: `>=1.14.0-0`

## Values

| Key                                                  | Type | Default                                              | Description |
|------------------------------------------------------|------|------------------------------------------------------|-------------|
| controller.affinity                                  | object | Hard node and soft zone anti-affinity                | Affinity for CSI Controller pod |
| controller.enabled                                   | bool | `true`                                               | Default is `true` |
| controller.nodeSelector                              | object | `{}`                                                 | Node selector for CSI Controller pod |
| controller.provisioner                               | bool | `false`                                              | Default is `false`. Enable provisioner of controller service. |
| controller.replicas                                  | int | `1`                                                  |  |
| controller.resources.limits.cpu                      | string | `"1000m"`                                            |  |
| controller.resources.limits.memory                   | string | `"1Gi"`                                              |  |
| controller.resources.requests.cpu                    | string | `"100m"`                                             |  |
| controller.resources.requests.memory                 | string | `"512Mi"`                                            |  |
| controller.service.port                              | int | `9909`                                               |  |
| controller.service.trpe                              | string | `"ClusterIP"`                                        |  |
| controller.terminationGracePeriodSeconds             | int | `30`                                                 | Grace period to allow the CSI Controller pod to shutdown before it is killed |
| controller.tolerations                               | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"}]` | Tolerations for CSI Controller pod |
| dnsConfig                                            | object | `{}`                                                 |  |
| dnsPolicy                                            | string | `"ClusterFirstWithHostNet"`                          |  |
| hostAliases                                          | list | `[]`                                                 |  |
| image.pullPolicy                                     | string | `""`                                                 |  |
| image.repository                                     | string | `"juicedata/juicefs-csi-driver"`                     |  |
| image.tag                                            | string | `"v0.18.0"`                                          |  |
| mountMode                                            | string | `"mountpod"`                                         | The way JuiceFS client runs |
| jfsConfigDir                                         | string | `"/var/lib/juicefs/config"`                          | JuiceFS config directory |
| jfsMountDir                                          | string | `"/var/lib/juicefs/volume"`                          | JuiceFS mount directory |
| kubeletDir                                           | string | `"/var/lib/kubelet"`                                 | The kubelet working directory, can be set using `--root-dir` when starting kubelet. |
| node.affinity                                        | object | Hard node and soft zone anti-affinity                | Affinity for CSI Node Service pods |
| node.enabled                                         | bool | `true`                                               | Default is `true`. CSI Node Service will be deployed in every node. |
| node.hostNetwork                                     | bool | `false`                                              |  |
| node.nodeSelector                                    | object | `{}`                                                 | Node selector for CSI Node Service pods. Refer to [this document](https://juicefs.com/docs/csi/guide/resource-optimization#running-csi-node-service-on-select-nodes) for more information. |
| node.resources.limits.cpu                            | string | `"1000m"`                                            |  |
| node.resources.limits.memory                         | string | `"1Gi"`                                              |  |
| node.resources.requests.cpu                          | string | `"100m"`                                             |  |
| node.resources.requests.memory                       | string | `"512Mi"`                                            |  |
| node.storageClassShareMount                          | bool | `false`                                              |  |
| node.terminationGracePeriodSeconds                   | int | `30`                                                 | Grace period to allow the CSI Node Service pods to shutdown before it is killed |
| node.tolerations                                     | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"}]` | Tolerations for CSI Node Service pods |
| serviceAccount.controller.annotations                | object | `{}`                                                 |  |
| serviceAccount.controller.create                     | bool | `true`                                               |  |
| serviceAccount.controller.name                       | string | `"juicefs-csi-controller-sa"`                        |  |
| serviceAccount.node.annotations                      | object | `{}`                                                 |  |
| serviceAccount.node.create                           | bool | `true`                                               |  |
| serviceAccount.node.name                             | string | `"juicefs-csi-node-sa"`                              |  |
| sidecars.csiProvisionerImage.repository              | string | `"quay.io/k8scsi/csi-provisioner"`                   |  |
| sidecars.csiProvisionerImage.tag                     | string | `"v1.6.0"`                                           |  |
| sidecars.livenessProbeImage.repository               | string | `"quay.io/k8scsi/livenessprobe"`                     |  |
| sidecars.livenessProbeImage.tag                      | string | `"v1.1.0"`                                           |  |
| sidecars.nodeDriverRegistrarImage.repository         | string | `"quay.io/k8scsi/csi-node-driver-registrar"`         |  |
| sidecars.nodeDriverRegistrarImage.tag                | string | `"v2.1.0"`                                           |  |
| storageClasses[0].backend.accessKey                  | string | `""`                                                 | Access key for object storage |
| storageClasses[0].backend.bucket                     | string | `""`                                                 | Bucket URL, for community edition use only. Refer to [this document](https://juicefs.com/docs/community/how_to_setup_object_storage) to learn how to setup different object storage. |
| storageClasses[0].backend.configs                    | string | `""`                                                 | Configuration for mount pod. Refer to [this document](https://juicefs.com/docs/csi/examples/config-and-env) for more information. |
| storageClasses[0].backend.envs                       | string | `""`                                                 | Environment variables for mount pod and `juicefs format` command, such as `{"a": "b"}`. Refer to [this document](https://juicefs.com/docs/csi/examples/config-and-env) for more information. |
| storageClasses[0].backend.formatOptions              | string | `""`                                                 | Options for `juicefs format` or `juicefs auth` command, connected by `,`, such as `block-size=4096,capacity=10`. Refer to ["Community Edition document"](https://juicefs.com/docs/community/command_reference#format) or ["Cloud Service document"](https://juicefs.com/docs/cloud/reference/commands_reference#auth) for more information. |
| storageClasses[0].backend.metaurl                    | string | `""`                                                 | Connection URL for metadata engine (e.g. Redis), for community edition use only. Refer to [this document](https://juicefs.com/docs/community/databases_for_metadata) for more information. |
| storageClasses[0].backend.name                       | string | `"juicefs"`                                          | The JuiceFS file system name |
| storageClasses[0].backend.secretKey                  | string | `""`                                                 | Secret key for object storage |
| storageClasses[0].backend.storage                    | string | `""`                                                 | Object storage type, such as `s3`, `gs`, `oss`, for community edition use only. Refer to [this document](https://juicefs.com/docs/community/how_to_setup_object_storage) for the full supported list. |
| storageClasses[0].backend.token                      | string | `""`                                                 | JuiceFS managed token, for cloud service use only. Refer to [this document](https://juicefs.com/docs/cloud/acl) for more details. |
| storageClasses[0].backend.trashDays                  | string | `""`                                                 | The number of days which files are kept in the trash, for community edition use only. Refer to [this document](https://juicefs.com/docs/community/security/trash) for more information. |
| storageClasses[0].cachePVC                           | string | `""`                                                 | Using PVC as JuiceFS cache path. Refer to [this document](https://juicefs.com/docs/csi/examples/cache-dir/#use-pvc-as-cache-path) for more details. |
| storageClasses[0].enabled                            | bool | `true`                                               | Default is `true` will create a new `StorageClass`. It will create `Secret` and `StorageClass` used by CSI Driver. |
| storageClasses[0].mountOptions                       | string | `nil`                                                | Options for `juicefs mount` command. Refer to ["Community Edition document"](https://juicefs.com/docs/community/command_reference#mount) or ["Cloud Service document"](https://juicefs.com/docs/cloud/reference/commands_reference#mount) for more information.<br/><br/> Example:<br/> - `debug`<br/> - `cache-size=2048`<br/> - `cache-dir=/var/foo` |
| storageClasses[0].mountPod.image                     | string | `"juicedata/mount:v1.0.3-4.8.3"`                     | Image of mount pod. Refer to [this document](https://juicefs.com/docs/csi/examples/mount-image) for more details. |
| storageClasses[0].mountPod.resources.limits.cpu      | string | `"5000m"`                                            |  |
| storageClasses[0].mountPod.resources.limits.memory   | string | `"5Gi"`                                              |  |
| storageClasses[0].mountPod.resources.requests.cpu    | string | `"1000m"`                                            |  |
| storageClasses[0].mountPod.resources.requests.memory | string | `"1Gi"`                                              |  |
| storageClasses[0].name | string | `"juicefs-sc"`                                       |  |
| storageClasses[0].reclaimPolicy | string | `"Delete"`                                           | Either Delete or Retain. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
