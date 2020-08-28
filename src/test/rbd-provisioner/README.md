# rbd-provisioner

The [rbd provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd) is an automatic provisioner for Kubernetes that uses your *already configured* ceph-rbd server, automatically creating Persistent Volumes.

## TL;DR;

```console
$ helm install --set ceph.mon=x.x.x.x,ceph.adminId=xxx,ceph.adminKey=xxx,ceph.userId=xxx,ceph.userKey=xxx -n=kube-system
```

## Prerequisites

- Kubernetes 1.9+
- Existing ceph server 

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --set ceph.mon=x.x.x.x,ceph.adminId=xxx,ceph.adminKey=xxx,ceph.userId=xxx,ceph.userKey=xxx -n=kube-system
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
| `ceph.adminId`                    | Admin ID of ceph server                     | `admin`                                     |
| `ceph.adminKey`                   | Admin Key of ceph server                    | null ( ceph auth get-key client.admin &#124; base64)   | 
| `ceph.userId`                     | User ID of ceph server (can be admin)       | `admin` |
| `ceph.userKey`                    | User Key of ceph server                     | null |
| `ceph.mon` 		                | Mon of ceph                                 | null						   |
| `ceph.pool`	                    | Pool of ceph                                | `rbd`						      |

