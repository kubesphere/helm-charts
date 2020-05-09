# RabbitMQ

## TL;DR;

```console
helm repo add ks-test https://charts.kubesphere.io/test
helm repo update
helm install ks-test/rabbitmq
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-test/rabbitmq
```

The command deploys the standalone RabbitMQ chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

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
`image.rabbitmq.repository` | The image of RabbitMQ container | `rabbitmq`
`image.rabbitmq.tag` | The tag of the RabbitMQ image | `3.8.1-alpine`
`image.rabbitmq.pullPolicy` | The pull policy of the RabbitMQ image | `IfNotPresent`
`extraPlugins` | Extra plugins enabled | `[]`
`extraConfigurations` | Extra configurations to append to rabbitmq.conf | ``
`advancedConfigurations` | advanced.config | ``
`defaultUsername` | The username of default user to interact with RabbitMQ | `admin`
`defaultPassword` | The password of default user to interact with RabbitMQ | `password`
`service.type` | The service type, can be `ClusterIP`, or `NodePort` | `ClusterIP`
