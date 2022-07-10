# ccm-qingcloud

## TL;DR;

```console
helm install ks-test/ccm-qingcloud
```

## Installing

To install the chart with the release name `my-release`:

```console
helm repo add ks-test https://charts.kubesphere.io/test
helm repo update
helm install --name my-release ks-test/ccm-qingcloud --namespace kube-system
```

The command deploys the standalone ccm-qingcloud chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete ccm-qingcloud --namespace kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the ccm-qingcloud chart and their default values.

Parameter | Description | Default
--- | --- | ---
`config.qy_access_key_id` | Access key id of QingCloud |
`config.qy_secret_access_key` | Access secret of QingCloud |
`config.zone` | Zone of QingCloud |
`config.host` | API host of QingCloud | `api.qingcloud.com`
`config.port` | API port of QingCloud | `443`
`config.protocol` | API protocol of QingCloud  | `https`
`config.uri` | API URI of QingCloud | `/iaas`
`config.vxnet` | Cluster vxnet of QingCloud |
`config.clusterID` | Cluster ID of QingCloud |
`config.userID` | QingCloud UserId |
`config.clusterTag` | Cluster tag of QingCloud |
`config.image` | Image of CCM | `qingcloud/cloud-controller-manager:v1.4.12`
`config.connection_retries` | Retry count of API | `3`
`config.connection_timeout` | Retry time out of API | `30`
