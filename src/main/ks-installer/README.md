# KubeSphere Helm Chart

## Introduction

[KubeSphere](https://kubesphere.io/) is a distributed operating system managing cloud native applications with Kubernetes as its kernel, and provides plug-and-play architecture for the seamless integration of third-party applications to boost its ecosystem.

The helm chart of KubeSphere, supports installing KubeSphere on existing Kubernetes.

## Prerequisites

 - Kubernetes v1.17.x、v1.18.x、v1.19.x、v1.20.x
 - PV dynamic provisioning support on the underlying infrastructure (StorageClass)
 - Helm3

## Installing

Check out configuration in `values.yaml` and install the chart with the release name `my-release`:

```console
helm install --name my-release ks-installer --namespace=kubesphere-system --create-namespace
```

The command deploys the kubesphere installer chart on the Kubernetes cluster.

## Uninstalling

show ks-installer chart
```console
helm list 
```

To uninstall/delete all charts related to ks-installer:

```console
helm delete my-release
```

The command removes ks-installer with the chart and deletes the release.

## Ks-installer Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v3.2.1`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`

## KubeSphere Configuration

You can set the configuration of kubesphere in `values.yaml`

Parameter | Description | Default
--- | --- | ---
`cc.persistence.storageClass` | Installer will use the default StorageClass, you can also designate another StorageClass| `""`
`cc.authentication.jwtSecret `| Keep the jwtSecret consistent with the host cluster. | `""`
`cc.etcd.monitoring `| Whether to enable etcd monitoring|`false`
`cc.etcd.endpointIps`|etcd address（for etcd cluster,see an example value like `192.168.0.7,192.168.0.8,192.168.0.9`）|`localhost` 
`cc.etcd.port`|etcd port (Default port: 2379, you can appoint any other port) | `2379` 
`cc.etcd.tlsEnable`|Whether to enable etcd TLS certificate authentication.（true / false）| `true`
`cc.common.redis.enabled`|Whether to install redis|`false`
`cc.common.redis.volumeSize`|redis volume size (cannot be modified after set)|`2Gi`
`cc.common.openldap.enabled`|Whether to install openldap|`false`
`cc.common.openldap.volumeSize`|openldap volume size (cannot be modified after set)|`2Gi`
`cc.common.minio.volumeSize`|Minio volume size (cannot be modified after set)|`20Gi`
`cc.common.es.master.volumeSize`|Volume size of Elasticsearch master nodes (cannot be modified after set)|`4Gi`
`cc.common.es.data.volumeSize`|Volume size of Elasticsearch data nodes (cannot be modified after set)|`20Gi`
`cc.common.es.logMaxAge`|Log retention time in built-in Elasticsearch (days)|`7`
`cc.common.es.elkPrefix`|redis volume size (cannot be modified after set)|`2Gi`
`cc.common.core.console.enableMultiLogin`|Whether to enable multiple point login of one account（true / false）|`false`
`cc.common.core.console.port`|Console Port（NodePort）|`30880`
`cc.alerting.enabled`|Whether to install KubeSphere alerting system. It enables Users to customize alerting policies to send messages to receivers in time with different time intervals and alerting levels to choose from. （true / false）|`false`
`cc.auditing.enabled`|Whether to install KubeSphere audit log system. It provides a security-relevant chronological set of records，recording the sequence of activities happened in platform, initiated by different tenants. （true / false）|`false`
`cc.devops.enabled`|Whether to install KubeSphere DevOps System. It provides out-of-box CI/CD system based on Jenkins, and automated workflow tools including Source-to-Image & Binary-to-Image. （true / false） | `false`
`cc.devops.jenkinsMemoryLim`|Jenkins Memory Limit|`2Gi`
`cc.devops.jenkinsMemoryReq`|Jenkins Memory Request|`1500Mi`
`cc.devops.jenkinsVolumeSize`|Jenkins volume size|`8Gi`
`cc.devops.jenkinsJavaOpts_Xms`|Jenkins JVM parameter（Xms）|`512m`
`cc.devops.jenkinsJavaOpts_Xmx`|Jenkins  JVM parameter（Xmx）|`512m`
`cc.devops.jenkinsJavaOpts_MaxRAM`|Jenkins  JVM parameter（MaxRAM）|`2Gi`
`cc.events.enabled`|Whether to install KubeSphere events system. It provides a graphical web console for Kubernetes Events exporting, filtering and alerting in multi-tenant Kubernetes clusters. （true / false）|`false`
`cc.logging.enabled`|Whether to install KubeSphere logging system. Flexible logging functions are provided for log query, collection and management in a unified console. Additional log collectors can be added, such as Elasticsearch, Kafka and Fluentd.  （true / false）|`false`
`cc.logging.logsidecar.replicas`|Logsidecar replicas|`2`
`cc.metrics_server.enabled`|Whether to install metrics_servertrue (true / false)| `false`
`cc.monitoring.storageClass`|If there is an independent StorageClass you need for Prometheus, you can specify it here| `""`
`cc.monitoring.gpu.nvidia_dcgm_exporter.enabled`|Whether to install GPU monitoring-related plugins.| `false`
`cc.multicluster.clusterRole`|You can install a solo cluster, or specify it as the role of host or member cluster. (host / member / none) |`none`
`cc.network.networkpolicy.enabled` |Network policies allow network isolation within the same cluster, which means firewalls can be set up between certain instances (Pods).  (true / false) |`false`
`cc.network.ippool.type` |Specify "calico" for this field if Calico is used as your CNI plugin. "none" means that Pod IP Pools are disabled.|`none`
`cc.network.topology.type` | Specify "weave-scope" for this field to enable Service Topology. "none" means that Service Topology is disabled.|`none`
`cc.openpitrix.store.enabled `|Enable or disable the KubeSphere App Store. (true / false) |`false`
`cc.servicemesh.enabled`|Whether to install KubeSphere Service Mesh (Istio-based). It provides fine-grained traffic management, observability and tracing, and offer visualization for traffic topology. (true / false) |`false`
`cc.kubeedge.enabled`|Add edge nodes to your cluster and deploy workloads on edge nodes. (true / false) |`false`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release ks-installer --set cc.persistence.storageClass=local
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
$ helm install my-release ks-installer -f values.yaml
```
