# Fluent Bit Operator

Fluent Bit Operator facilitates the deployment of Fluent Bit and provides great flexibility in building a logging layer based on Fluent Bit. Learn more: https://github.com/fluent/fluentbit-operator

## Introduction

This [Helm](https://github.com/kubernetes/helm) chart installs [Fluent Bit Operator]( https://github.com/fluent/fluentbit-operator) in a Kubernetes cluster. Welcome to contribute to Helm Chart for Fluent Bit Operator.

## Prerequisites

- Kubernetes v1.16.13+
- Helm v3.2.1+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release  --create-namespace -n kubesphere-logging-system stable/fluentbit-operator
```

The command deploys Fluent Bit Operator on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

Assuming your release is named as `my-release`, delete it using the command:

```bash
$ helm uninstall my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Elasticsearch-Exporter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`operator.image` | The image of `Fluent Bit Operator `container | `kubesphere/fluentbit-operator` 
`operator.tag` | The tag of `Fluent Bit Operator` container | `v0.9.0` 
`operator.initcontainer.image` | The image of  initial container.It is used to set `Fluent Bit` environment variables | `docker` 
`operator.initcontainer.tag` | The tag of  initial container. | `19.03` 
`fluentbit.image` | The image of `Fluent Bit` container | `kubesphere/fluent-bit` 
`fluentbit.tag` | The tag of `Fluent Bit` container | `v1.8.3` 
`imagePullSecrets` | Image pull secrets | `[]` 
 `nameOverride`                                  | Provide a name in place of `Fluent Bit Operator`             | `""`                                                         
 `fullnameOverride`                              | Provide a name to substitute for the full names of resources | `""`                                                         
`namespaceOverride` | Override the deployment namespace | `""` 
`resources.fluentbit.resources.limits.cpu` | `Fluent bit` Pod resource requests & limits | `500m` 
`resources.fluentbit.resources.limits.memory` | `Fluent bit` Pod resource requests & limits | `200Mi` 
`resources.fluentbit.resources.requests.cpu` | `Fluent bit` Pod resource requests & limits | `10m` 
`resources.fluentbit.resources.requests.memory` | `Fluent bit` Pod resource requests & limits | `25Mi` 
`resources.operator.resources.limits.cpu` | `Fluent Bit Operator` Pod resource requests & limits | `100m` 
`resources.operator.resources.limits.memory` | `Fluent Bit Operator` Pod resource requests & limits | `30Mi` 
`resources.operator.resources.requests.cpu` | `Fluent Bit Operator` Pod resource requests & limits | `100m` 
`resources.operator.resources.requests.memory` | `Fluent Bit Operator` Pod resource requests & limits | `20Mi` 
 `Kubernetes`                                     | if `true`, it wll deploy log input/filter/output configurations to collect Kubernetes logs including container logs and kubelet logs. | `false` 
`input.tail.memBufLimit` | Set a limit of memory that Tail plugin can use when appending data to the Engine | `5MB` 
`containerRuntime` | Set different `containerRuntime` depending on  your container runtime( `containerd` , `cri-o` ,`docker`) | `docker` 
`logPath.crio` | Set the fluentBit mount path when your container time is `cri-o` | `/var/log` 
`output.es.enables` | if `true`, logs will be output to the Elasticsearch | `false` 
`output.es.host` | the host of  the Elasticsearch | `<Elasticsearch url like elasticsearch-logging-data.kubesphere-logging-system.svc>` 
`output.es.port` | the port of  the Elasticsearch | `9200` 
`output.forward.enables` | if `true`, logs will be output to the fluentd | `false` 
`output.forward.host` | the host of  the fluentd | `<fluentd url like fluentd.kubesphere-logging-system.svc>` 
`output.forward.port` | the port of  the fluentd | `24224` 
`output.kafka.enable` | if `true`, logs will be output to the kafka | `false` 
`output.kafka.brokers` | the brokers of the kafka | `<kafka broker list like xxx.xxx.xxx.xxx:9092,yyy.yyy.yyy.yyy:9092>` 

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release --create-namespace -n kubesphere-logging-system \
    --set key_1=value_1,key_2=value_2 \
    stable/fluentbit-operator
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release --create-namespace -n kubesphere-logging-system -f values.yaml stable/fluentbit-operator
```

> **Tip**: You can use the default [values.yaml](values.yaml)

