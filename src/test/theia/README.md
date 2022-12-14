# theia

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Antrea Network Flow Visibility

**Homepage:** <https://antrea.io/>

## Source Code

* <https://github.com/antrea-io/theia>

## Requirements

Kubernetes: `>= 1.16.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clickhouse.cluster.installZookeeper.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-zookeeper","tag":"3.8.0"}` | Container image used by the ZooKeeper. |
| clickhouse.cluster.installZookeeper.replicas | int | `1` | Number of ZooKeeper replicas. It is recommended to be odd. When deploying ClickHouse cluster with more than 1 replica, 3 is the minimum number of ZooKeeper hosts required to manage replication and fault tolerance. Please refer to <https://zookeeper.apache.org/doc/current/zookeeperStarted.html#sc_RunningReplicatedZooKeeper> for more information. |
| clickhouse.cluster.installZookeeper.securityContext | object | `{"fsGroup":1000,"runAsUser":1000}` | Set securityContext. Use a specific uid, gid for zookeeper. |
| clickhouse.cluster.installZookeeper.size | string | `"5Gi"` | Memory size for each ZooKeeper pod. Can be a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, K. Or the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. |
| clickhouse.cluster.podDistribution | list | `[{"number":1,"topologyKey":"kubernetes.io/hostname","type":"MaxNumberPerNode"}]` | Affinity for the ClickHouse Pods. By default, it allows only one ClickHouse instance per Node. Please refer to <https://github.com/Altinity/clickhouse-operator/blob/master/docs/chi-examples/99-clickhouseinstallation-max.yaml> for other distributions. |
| clickhouse.cluster.replicas | int | `1` | Number of ClickHouse replicas in each shard. |
| clickhouse.cluster.shards | int | `1` | Number of ClickHouse shards in the cluster. |
| clickhouse.cluster.zookeeperHosts | list | `[]` | To use a pre-installed ZooKeeper for ClickHouse data replication, please provide a list of your ZooKeeper hosts. To install a customized ZooKeeper, refer to <https://github.com/Altinity/clickhouse-operator/blob/master/docs/zookeeper_setup.md> |
| clickhouse.connectionSecret | object | `{"password":"clickhouse_operator_password","username":"clickhouse_operator"}` | Credentials to connect to ClickHouse. They will be stored in a secret. |
| clickhouse.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-clickhouse-server","tag":""}` | Container image used by ClickHouse. |
| clickhouse.monitor.deletePercentage | float | `0.5` | The percentage of records in ClickHouse that will be deleted when the storage grows above threshold. Vary from 0 to 1. |
| clickhouse.monitor.enable | bool | `true` | Determine whether to run a monitor to periodically check the ClickHouse memory usage and clean data. |
| clickhouse.monitor.execInterval | string | `"1m"` | The time interval between two round of monitoring. Can be a plain integer using one of these unit suffixes ns, us (or µs), ms, s, m, h. |
| clickhouse.monitor.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-clickhouse-monitor","tag":""}` | Container image used by the ClickHouse Monitor. |
| clickhouse.monitor.skipRoundsNum | int | `3` | The number of rounds for the monitor to stop after a deletion to wait for the ClickHouse MergeTree Engine to release memory. |
| clickhouse.monitor.threshold | float | `0.5` | The storage percentage at which the monitor starts to delete old records. Vary from 0 to 1. |
| clickhouse.service.httpPort | int | `8123` | HTTP port number for the ClickHouse service. |
| clickhouse.service.tcpPort | int | `9000` | TCP port number for the ClickHouse service. |
| clickhouse.service.type | string | `"ClusterIP"` | The type of Service exposing ClickHouse. It can be one of ClusterIP, NodePort or LoadBalancer. |
| clickhouse.storage.createPersistentVolume.local.affinity | object | `{}` | Affinity for the Local PersistentVolume. By default it requires to label the Node used to store the ClickHouse data with "antrea.io/clickhouse-data-node=". |
| clickhouse.storage.createPersistentVolume.local.nodes | list | `["kind-worker"]` | A list of Node hostnames. Required when type is "Local". Please make sure to provide (shards * replicas) Nodes. Each Node should meet affinity and have the path created on it. |
| clickhouse.storage.createPersistentVolume.local.path | string | `"/data/clickhouse"` | The local path. Required when type is "Local". |
| clickhouse.storage.createPersistentVolume.nfs.addresses | list | `["nfs.svc.cluster.local:/data"]` | A list of addresses for NFS shares in the format hostname:path, where hostname refers to NFS server hostname or IP address, and path refers to the path exported on the NFS server. Please provide (shards * replicas) addresses. |
| clickhouse.storage.createPersistentVolume.type | string | `""` | Type of PersistentVolume. Can be set to "Local" or "NFS". Please set this value to use a PersistentVolume created by Theia. |
| clickhouse.storage.persistentVolumeClaimSpec | object | `{}` | Specification for PersistentVolumeClaim. This is ignored if createPersistentVolume.type is non-empty. To use a custom PersistentVolume, please set storageClassName: "" volumeName: "<my-pv>". To dynamically provision a PersistentVolume, please set storageClassName: "<my-storage-class>". Memory storage is used if both createPersistentVolume.type and persistentVolumeClaimSpec are empty. |
| clickhouse.storage.size | string | `"8Gi"` | ClickHouse storage size. Can be a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, K. Or the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. |
| clickhouse.ttl | string | `"12 HOUR"` | Time to live for data in the ClickHouse. Can be a plain integer using one of these unit suffixes SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR. |
| grafana.dashboards | list | `["homepage.json","flow_records_dashboard.json","pod_to_pod_dashboard.json","pod_to_service_dashboard.json","pod_to_external_dashboard.json","node_to_node_dashboard.json","networkpolicy_dashboard.json"]` | The dashboards to be displayed in Grafana UI. The files must be put under provisioning/dashboards. |
| grafana.enable | bool | `true` | Determine whether to install Grafana. It is used as a data visualization and monitoring tool.   |
| grafana.homeDashboard | string | `"homepage.json"` | Default home dashboard. |
| grafana.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-grafana","tag":"8.3.3"}` | Container image used by Grafana. |
| grafana.installPlugins | list | `["https://downloads.antrea.io/artifacts/grafana-custom-plugins/theia-grafana-sankey-plugin-1.0.2.zip;theia-grafana-sankey-plugin","https://downloads.antrea.io/artifacts/grafana-custom-plugins/theia-grafana-chord-plugin-1.0.1.zip;theia-grafana-chord-plugin","grafana-clickhouse-datasource 1.0.1"]` | Grafana plugins to install. |
| grafana.loginSecret | object | `{"password":"admin","username":"admin"}` | Credentials to login to Grafana. They will be stored in a Secret. |
| grafana.securityContext | object | `{"fsGroup":472,"supplementalGroups":[0]}` | Set securityContext. Use a specific uid, gid for grafana. |
| grafana.service.tcpPort | int | `3000` | TCP port number for the Grafana service. |
| grafana.service.type | string | `"NodePort"` | The type of Service exposing Grafana. It must be one of NodePort or LoadBalancer. |
| grafana.storage.createPersistentVolume.hostPath.path | string | `"/data/grafana"` | The host path. Required when type is "HostPath". |
| grafana.storage.createPersistentVolume.local.affinity | object | `{}` | Affinity for the Local PersistentVolume. By default it requires to label the Node used to store the Grafana configuration files with "antrea.io/grafana-config-node=". |
| grafana.storage.createPersistentVolume.local.path | string | `"/data/grafana"` | The local path. Required when type is "Local". |
| grafana.storage.createPersistentVolume.nfs.host | string | `""` | The NFS server hostname or IP address. Required when type is "NFS". |
| grafana.storage.createPersistentVolume.nfs.path | string | `""` | The path exported on the NFS server. Required when type is "NFS". |
| grafana.storage.createPersistentVolume.type | string | `"HostPath"` | Type of PersistentVolume. Can be set to "HostPath", "Local" or "NFS". Please set this value to use a PersistentVolume created by Theia. |
| grafana.storage.persistentVolumeClaimSpec | object | `{}` | Specification for PersistentVolumeClaim. This is ignored if createPersistentVolume.type is non-empty. To use a custom PersistentVolume, please set storageClassName: "" volumeName: "<my-pv>". To dynamically provision a PersistentVolume, please set storageClassName: "<my-storage-class>". HostPath storage is used if both createPersistentVolume.type and persistentVolumeClaimSpec are empty. |
| grafana.storage.size | string | `"1Gi"` | Grafana storage size. It is used to store Grafana configuration files. Can be a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, K. Or the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. |
| sparkOperator.enable | bool | `false` | Determine whether to install Spark Operator. It is required to run Network Policy Recommendation jobs. |
| sparkOperator.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-spark-operator","tag":"v1beta2-1.3.3-3.1.1"}` | Container image used by Spark Operator. |
| sparkOperator.name | string | `"policy-recommendation"` | Name of Spark Operator. |
| theiaManager.apiServer.apiPort | int | `11347` | The port for the Theia Manager APIServer to serve on. |
| theiaManager.apiServer.selfSignedCert | bool | `true` | Indicates whether to use auto-generated self-signed TLS certificates. If false, a Secret named "theia-manager-tls" must be provided with the following keys: ca.crt, tls.crt, tls.key. |
| theiaManager.apiServer.tlsCipherSuites | string | `""` | Comma-separated list of cipher suites that will be used by the Theia Manager APIservers. If empty, the default Go Cipher Suites will be used. |
| theiaManager.apiServer.tlsMinVersion | string | `""` | TLS min version from: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13. |
| theiaManager.enable | bool | `false` | Determine whether to install Theia Manager. |
| theiaManager.image | object | `{"pullPolicy":"IfNotPresent","repository":"projects.registry.vmware.com/antrea/theia-manager","tag":""}` | Container image used by Theia Manager. |
| theiaManager.logVerbosity | int | `0` | Log verbosity switch for Theia Manager. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)
