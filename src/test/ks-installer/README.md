# Ks-installer Helm Chart

## Introduction

The helm chart of KubeSphere, supports installing KubeSphere on existing Kubernetes.

## Prerequisites

 - Kubernetes v1.15.x、v1.16.x、v1.17.x、v1.18.x
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

To uninstall/delete all charts related to kubesphere:

```console
helm delete my-release
```

The command removes ks-installer with the chart and deletes the release.

## Ks-installer Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v3.0.0`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`

## KubeSphere Configuration

You can set the configuration of kubespher in `values.yaml`,`etcd.endpointIps` must be set your etcd ip

Parameter | Description | Default
--- | --- | ---
`persistence.storageClass` | Installer will use the default StorageClass, you can also designate another StorageClass| `""`
`authentication.jwtSecret `| Keep the jwtSecret consistent with the host cluster. | `""`
`etcd.monitoring `| Whether to enable etcd monitoring|`false`
`etcd.endpointIps`|etcd address（for etcd cluster,see an example value like `192.168.0.7,192.168.0.8,192.168.0.9`）|`localhost` 
`etcd.port`|etcd port (Default port: 2379, you can appoint any other port) | `2379` 
`etcd.tlsEnable`|Whether to enable etcd TLS certificate authentication.（true / false）| `true`
`common.mysqlVolumeSize`|MySQL volume size (cannot be modified after set)|`20Gi`
`common.minioVolumeSize`|Minio volume size (cannot be modified after set)|`20Gi`
`common.etcdVolumeSize`|etcd volume size (cannot be modified after set) |`20Gi`
`common.openldapVolumeSize`|openldap volume size (cannot be modified after set)|`2Gi`
`common.redisVolumSize`|redis volume size (cannot be modified after set)|`2Gi`
`common.es.elasticsearchMasterVolumeSize`|Volume size of Elasticsearch master nodes (cannot be modified after set)|`4Gi`
`common.es.elasticsearchDataVolumeSize`|Volume size of Elasticsearch data nodes (cannot be modified after set)|`20Gi`
`common.es.logMaxAge`|Log retention time in built-in Elasticsearch (days)|`7`
`common.es.elkPrefix`|redis volume size (cannot be modified after set)|`2Gi`
`console.enableMultiLogin`|Whether to enable multiple point login of one account（true / false）|`false`
`console.port`|Console Port（NodePort）|`30880`
`alerting.enabled`|Whether to install KubeSphere alerting system. It enables Users to customize alerting policies to send messages to receivers in time with different time intervals and alerting levels to choose from. （true / false）|`false`
`auditing.enabled`|Whether to install KubeSphere audit log system. It provides a security-relevant chronological set of records，recording the sequence of activities happened in platform, initiated by different tenants. （true / false）|`false`
`devops.enabled`|Whether to install KubeSphere DevOps System. It provides out-of-box CI/CD system based on Jenkins, and automated workflow tools including Source-to-Image & Binary-to-Image. （true / false） | `false`
`devops.jenkinsMemoryLim`|Jenkins Memory Limit|`2Gi`
`devops.jenkinsMemoryReq`|Jenkins Memory Request|`1500Mi`
`devops.jenkinsVolumeSize`|Jenkins volume size|`8Gi`
`devops.jenkinsJavaOpts_Xms`|Jenkins JVM parameter（Xms）|`512m`
`devops.jenkinsJavaOpts_Xmx`|Jenkins  JVM parameter（Xmx）|`512m`
`devops.jenkinsJavaOpts_MaxRAM`|Jenkins  JVM parameter（MaxRAM）|`2Gi`
`events.enabled`|Whether to install KubeSphere events system. It provides a graphical web console for Kubernetes Events exporting, filtering and alerting in multi-tenant Kubernetes clusters. （true / false）|`false`
`logging.enabled`|Whether to install KubeSphere logging system. Flexible logging functions are provided for log query, collection and management in a unified console. Additional log collectors can be added, such as Elasticsearch, Kafka and Fluentd.  （true / false）|`false`
`logging.logsidecarReplicas`|Logsidecar replicas|`2`
`metrics_server.enabled`|Whether to install metrics_servertrue / false）| `false`
`monitoring.prometheusMemoryRequest`|Prometheus memory request|`400Mi`
`monitoring.prometheusVolumeSize`|Prometheus volume size|`20Gi`
`multicluster.clusterRole`|You can install a solo cluster, or specify it as the role of host or member cluster. （host / member / none）|`none`
`networkpolicy.enabled`|Network policies allow network isolation within the same cluster, which means firewalls can be set up between certain instances (Pods). （true / false）|`false`
`notification.enable`|Email Notification support for the legacy alerting system, should be enabled/disabled together with the above alerting option. （true / false）|`false`
`openpitrix.enable`|Whether to install KubeSphere Application Store. It provides an application store for Helm-based applications, and offer application lifecycle management. （true / false）|`false`
`servicemesh.enabled`|Whether to install KubeSphere Service Mesh (Istio-based). It provides fine-grained traffic management, observability and tracing, and offer visualization for traffic topology. （true / false）|`false`


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release ks-installer --set persistence.storageClass=local
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
$ helm install my-release ks-installer -f values.yaml
```
