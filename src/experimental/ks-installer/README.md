# Ks-installer Helm Chart

## Introduction

The helm chart of KubeSphere, supports installing KubeSphere on existing Kubernetes.

## Prerequisites

 - Kubernetes v1.14.x、v1.15.x、v1.16.x、v1.17.3
 - PV dynamic provisioning support on the underlying infrastructure (StorageClass)
 - Helm 2

## Installing

Check out configuration in `values.yaml` and install the chart with the release name `my-release`:

```console
helm install --name my-release ks-installer
```

The command deploys the kubesphere installer chart on the Kubernetes cluster.

## Uninstalling

show ks-installer chart
```console
helm list 
```

To uninstall/delete all charts related to kubesphere:

```console
helm delete --purge my-release
```

The command removes ks-installer with the chart and deletes the release.

## Ks-installer Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v2.1.1`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`

## KubeSphere Configuration

You can set the configuration of kubespher in `values.yaml`,`etcd.endpointIps` must be set your etcd ip

Parameter | Description | Default
--- | --- | ---
`persistence.storageClass` | Installer will use the default StorageClass, you can also designate another StorageClass| `""`
`etcd.monitoring `| Whether to enable etcd monitoring|`False`
`etcd.endpointIps`|etcd address（for etcd cluster,see an example value like `192.168.0.7,192.168.0.8,192.168.0.9`）|`192.168.0.7,192.168.0.8,192.168.0.9` 
`etcd.port`|etcd port (Default port: 2379, you can appoint any other port) | `2379` 
`etcd.tlsEnable`|Whether to enable etcd TLS certificate authentication.（True / False）| `True`
`common.mysqlVolumeSize`|MySQL volume size (cannot be modified after set)|`20Gi`
`common.minioVolumeSize`|Minio volume size (cannot be modified after set)|`20Gi`
`common.etcdVolumeSize`|etcd volume size (cannot be modified after set) |`20Gi`
`common.openldapVolumeSize`|openldap volume size (cannot be modified after set)|`2Gi`
`common.redisVolumSize`|redis volume size (cannot be modified after set)|`2Gi`
`console.enableMultiLogin`|Whether to enable multiple point login of one account（True / False）|`False`
`console.port`|Console Port（NodePort）|`30880`
`monitoring.prometheusReplicas`|Prometheus replicas|`1`
`monitoring.prometheusMemoryRequest`|Prometheus memory request|`400Mi`
`monitoring.prometheusVolumeSize`|Prometheus volume size|`20Gi`
`monitoring.grafana.enabled`|Whether to enable Grafana installation（True / False）|`False`
`openpitrix.enable`|App store and app templates are based on OpenPitrix, it's recommended to enable OpenPitrix installation（True / False）,it need at least 0.3 core, 300 MiB|`False`
`logging.enabled`|Whether to enable logging system installation   （True / False）|`False`
`logging.elasticsearchMasterReplicas`|Elasticsearch master replicas|`1`
`logging.elasticsearchDataReplicas`|Elasticsearch data replicas|`1`
`logging.logsidecarReplicas`|Logsidecar replicas|`2`
`logging.elasticsearchVolumeSize`|ElasticSearch volume size|`20Gi`
`logging.logMaxAge`|How many days the logs are remained|`7`
`logging.elkPrefix`|Log index |`logstash `
`logging.containersLogMountedPath`|The mounting path of container logs|`""`
`logging.kibana.enabled`|Whether to enable Kibana installation（True / False）|`False`
`devops.enabled`|Whether to enable DevOps system installation（True / False）`False`
`devops.jenkinsMemoryLim`|Jenkins Memory Limit|`2Gi`
`devops.jenkinsMemoryReq`|Jenkins Memory Request|`1500Mi`
`devops.jenkinsVolumeSize`|Jenkins volume size|`8Gi`
`devops.jenkinsJavaOpts_Xms`|Jenkins JVM parameter（Xms）|`512m`
`devops.jenkinsJavaOpts_Xmx`|Jenkins  JVM parameter（Xmx）|`512m`
`devops.jenkinsJavaOpts_MaxRAM`|Jenkins  JVM parameter（MaxRAM）|`2Gi`
`devops.sonarqube.enabled`|Whether to install SonarQube（True / False）|`False`
`metrics_server.enabled`|Whether to install metrics_serverTrue / False）| `False`
`servicemesh.enabled`|Whether to install Istio（True / False）|`False`
`notification.enable`|Whether to install Notification sysytem （True / False）|`False`
`alerting.enabled`|Whether to install Alerting sysytem （True / False）|`False`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release ks-installer --set persistence.storageClass=local
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```console
$ helm install my-release ks-installer -f values.yaml
```
