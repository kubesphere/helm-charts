# Redis

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release experimental/ks-installer
```

The command deploys the kubesphere installer chart on the Kubernetes cluster in the default configuration. 

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the ks-installer chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | The image of ks-installer container | `kubesphere/ks-installer`
`image.tag` | The tag of the ks-installer image | `v2.1.1`
`image.pullPolicy` | The pull policy of the ks-installer image | `Always`
`config.date`| The ConfigMap of the ks-installer| `    persistence:
      storageClass: ""
    etcd:
      monitoring: False
      endpointIps: 192.168.3.11,192.168.3.12,192.168.3.13
      port: 2379
      tlsEnable: True
    common:
      mysqlVolumeSize: 20Gi
      minioVolumeSize: 20Gi
      etcdVolumeSize: 20Gi
      openldapVolumeSize: 2Gi
      redisVolumSize: 2Gi
    metrics_server:
      enabled: False
    console:
      enableMultiLogin: False  # enable/disable multi login
      port: 30880
    monitoring:
      prometheusReplicas: 1
      prometheusMemoryRequest: 400Mi
      prometheusVolumeSize: 20Gi
      grafana:
        enabled: False
    logging:
      enabled: True
      elasticsearchMasterReplicas: 1
      elasticsearchDataReplicas: 1
      logsidecarReplicas: 2
      elasticsearchMasterVolumeSize: 4Gi
      elasticsearchDataVolumeSize: 20Gi
      logMaxAge: 7
      elkPrefix: logstash
      containersLogMountedPath: ""
      kibana:
        enabled: False
    openpitrix:
      enabled: False
    devops:
      enabled: False
      jenkinsMemoryLim: 2Gi
      jenkinsMemoryReq: 1500Mi
      jenkinsVolumeSize: 8Gi
      jenkinsJavaOpts_Xms: 512m
      jenkinsJavaOpts_Xmx: 512m
      jenkinsJavaOpts_MaxRAM: 2g
      sonarqube:
        enabled: False
        postgresqlVolumeSize: 8Gi
    servicemesh:
      enabled: False
    notification:
      enabled: False
    alerting:
      enabled: False `