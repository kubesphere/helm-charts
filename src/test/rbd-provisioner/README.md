# rbd-provisioner

The [rbd provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd) is an automatic provisioner for Kubernetes that uses your *already configured* ceph-rbd server, automatically creating Persistent Volumes.

## TL;DR;

```console
$ helm install test/rbd-provisioner -n kube-system --name-template=rbd-provisioner --set ceph.mon=,ceph.adminKey=,ceph.userKey=
```

## Prerequisites

- Kubernetes 1.9+
- Existing ceph server 

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm repo add test https://charts.kubesphere.io/test
helm install test/rbd-provisioner -n kube-system --name-template=rbd-provisioner --set ceph.mon=,ceph.adminKey=,ceph.userKey=

```

> **Tip**: List all releases using `helm list -n kube-system`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release -n kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of this chart and their default values.

| Parameter                         | Description                                 | Default                                                   |
| --------------------------------- | -------------------------------------       | --------------------------------------------------------- |
| `image.repository`                | Provisioner image                           | `kubesphere/rbd-provisioner`         |
| `image.tag`                       | Version of provisioner image                | `v2.1.1-k8s1.11`                                          |
| `image.pullPolicy`                | Image pull policy                           | `IfNotPresent`                                            |
| `sc.create`                       | Create StorageClass or not                  | `true`                                              |
| `sc.name`                         | Name of the StorageClass                    | `rbd`                                              |
| `sc.isDefault`                    | Set as the default StorageClass             | `false`	                                              |
| `sc.reclaimPolicy`                | Method used to reclaim an obsoleted volume  | `Delete` 	                              |
| `sc.provisioner`                  | Name of the provisioner                     |  `ceph.com/rbd`                                         |
| `sc.fyType`                       | Filesystem type the StorageClass            |  `ext4`                                         |
| `sc.imageFormat`                  | ImageFormat parameter of the StorageClass   |  `2`                             |
| `sc.imageFeatures`                | ImageFeatures parameter of StorageClass      |  `layering`                                         |
| `ceph.adminId`                    | Admin ID of ceph server                     | `admin`                                     |
| `ceph.adminKey`                   | Admin Key of ceph server                    | null ( ceph auth get-key client.admin &#124; base64)   | 
| `ceph.userId`                     | User ID of ceph server (can be admin)       | `admin` |
| `ceph.userKey`                    | User Key of ceph server                     | null |
| `ceph.mon` 		                | Mon of ceph                                 | null						   |
| `ceph.pool`	                    | Pool of ceph                                | `rbd`						      |

