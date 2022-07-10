# CNI-Hostnic

## TL;DR;

```console
helm repo add ks-test https://charts.kubesphere.io/test
helm repo update
helm install ks-test/cni-hostnic
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-test/cni-hostnic
```

**hostnic-cni** is a [Container Network Interface](https://github.com/containernetworking/cni) plugin. This plugin will create a new nic by IaaS api and attach to host, then move the nic to container network namespace. Support IaaS :[QingCloud](http://qingcloud.com).

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the rabbitmq chart and their default values.

Parameter | Description | Default
--- | --- | ---
`config.image` | The image of CNI-Hostnic container | `qingcloud/hostnic-plus:v1.0.3`
`config.qy_access_key_id` | Access key id of QingCloud |
`config.qy_secret_access_key` | Access secret of QingCloud |
`config.zone` | Zone of QingCloud |
`config.host` | API host of QingCloud | `api.qingcloud.com`
`config.port` | API port of QingCloud | `443`
`config.protocol` | API protocol of QingCloud | `https`
`config.uri` | API URI of QingCloud | `/iaas`
`config.cidr` | dst destination subnet specified in CIDR notation |
`config.networkpolicy` | Calico networkpolicy |
`config.blocksize` | SubnetMasks blocksize |
`config.vxnets` | hostnic Vxnet of QIngCloud |
`config.auto` | subnet-auto-assign |
`config.ipam` | IP Address Management |
`config.vxnet` | default VxNet For LB |
`config.clusterID` | Cluster Id of QingCloud |
`config.userID` | Cluster User of QingCloud |
`config.clusterTag` | Cluster Tag of QingCloud |
`config.connection_retries` | Retry count of API | `3`
`config.connection_timeout` | Retry time out of API | `30`