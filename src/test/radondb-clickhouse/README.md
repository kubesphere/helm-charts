# RadonDB ClickHouse

RadonDB ClickHouse is an open-source, cloud-native, High-Availability cluster solutions based on [ClickHouse](https://clickhouse.tech/).

[ClickHouse](https://clickhouse.tech/) is an open source column-oriented database management system capable of real time generation of analytical data reports using 
SQL queries.


# Github

https://github.com/radondb/clickhouse-cluster-helm

# Introduction

A ClickHouse cluster relies on ZooKeeper to store metadata.

So this chart will install [ZooKeeper](https://zookeeper.apache.org/) and [ClickHouse](https://clickhouse.tech/).

# Prerequisites

- Kubernetes 1.10+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- Helm 3.0-beta3+

# Installing the Chart

The command deploys MySQL cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

```bash
$ helm repo add radonck https://radondb.github.io/clickhouse-cluster-helm/
$ helm repo update
$ helm install clickhouse radonck/clickhouse
$  helm list 
NAME      	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
clickhouse	default  	1       	2021-06-07 07:55:42.860240764 +0000 UTC	deployed	clickhouse-0.1.0	21.1    

```

In default, the chart will create a ClickHouse Cluster with one shard and two replicas.

# Uninstall

To uninstall/delete the `clickhouse` deployment:

```bash
$ helm delete clickhouse
```

To delete the pvc:

```
kubectl delete pvc ck-datadir-clickhouse-s0-r0-0 
kubectl delete pvc ck-datadir-clickhouse-s0-r1-0 
kubectl delete pvc datadir-volume-zk-clickhouse-0 
kubectl delete pvc datadir-volume-zk-clickhouse-1 
kubectl delete pvc datadir-volume-zk-clickhouse-2
```

The commands remove all the Kubernetes components associated with the chart and deletes the release completely.

# Configuration

The following table lists the configurable parameters of the RadonDB MySQL chart and their default values.

| Parameter                                    | Description                                                                                       | Default                                     |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `clickhouse.clusterName`                            | ClickHouse Default Cluster Name                                                                                 | `cluster`                              |
| `clickhouse.resources.cpu`                            | ClickHouse Resource/Limit cpu                                                                                 | `0.5`                              |
| `clickhouse.resources.memory`                            | ClickHouse Resource/Limit memory                                                                                 | `1Gi`                              |
| `clickhouse.users.username`                            | ClickHouse user name                                                                                 | `default`                              |
| `clickhouse.users.password`                            | ClickHouse user password                                                                                  | `C1ickh0use`                              |
| `clickhouse.ports.native`                            | Port for the [native CLI interface](https://clickhouse.tech/docs/en/interfaces/tcp/)                                                                                  | `9000`                              |
| `clickhouse.ports.http`                            | Port for the [HTTP/REST interface](https://clickhouse.tech/docs/en/interfaces/http/)                                                                                  | `8123`                              |
| `clickhouse.shards.name`                            | [Shart configuration](https://clickhouse.tech/docs/en/operations/table_engines/distributed/)                                                                                  | `shard0`                              |
| `clickhouse.shards.replicas`                            | [Replicas configuration](https://clickhouse.tech/docs/en/operations/table_engines/distributed/)                                                                                  | `shard0-replica0, shard0-replica1`                              |
| `clickhouse.image`                            | ClickHouse Image                                                                                 | `tceason/clickhouse-server:v21.1.3.32-stable`                              |
| `clickhouse.imagePullPolicy`                            | ClickHouse Image pull policy                                                                                 | `IfNotPresent`                              |
| `clickhouse.service.type`                            | Type of the service.                                                                                 | `ClusterIP`                              |
| `clickhouse.livenessProbe.initialDelaySeconds`  | Delay before ClickHouse liveness probe is initiated                                                  | 30                                          |
| `clickhouse.livenessProbe.periodSeconds`  |  How often to perform the ClickHouse probe                                                         | 30                                          |
| `clickhouse.livenessProbe.timeoutSeconds`       | When the probe times out                                                                          | 5                                           |
| `clickhouse.livenessProbe.failureThreshold`  | ClickHouse Failure Threshold                                                  | 3                                          |
| `clickhouse.livenessProbe.successThreshold`  | ClickHouse Success Threshold                                                  | 1                                          |
| `zookeeper.replicas`  | Nums of Zookeeper replicas                                                | 3                                          |
| `zookeeper.image`  | Zookeeper Image                                                | 3                                          | `tceason/zookeeper:3.6.2`
| `zookeeper.imagePullPolicy`                            | Zookeeper Image pull policy                                                                                 | `IfNotPresent`                              |
| `zookeeper.resources.cpu`                            | zookeeper Resource/Limit cpu                                                                                 | `0.5`                              |
| `zookeeper.resources.memory`                            | zookeeper Resource/Limit memory                                                                                 | `1Gi`                         

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ cd clickhouse-cluster-helm/clickhouse/
$ helm install clickhouse \
  --set clickhouse.users[0].username=my-user,clickhouse.users[0].password=my-password .

```

The above command creates a standard database user named `my-user`, with the password `my-password`.
```bash
$ kubectl exec -it clickhouse-s0-r0-0 -- clickhouse client -u my-user --password=my-password --query='select hostName()'
clickhouse-s0-r0-0

```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ cd clickhouse-cluster-helm/clickhouse/
$ helm install clickhouse -f values.yaml .

```

## Persistence

You can configure a Pod to use a PersistentVolumeClaim(PVC) for storage.
In default, PVC mount on the `/var/lib/clickhouse` directory.

1. You should create a Pod that uses the above PVC for storage.

2. You should create a PVC that is automatically bound to a suitable PersistentVolume(PV).

> **Note**
> PVC can use different PV, so using the different PV show the different performance.
