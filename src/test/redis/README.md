# Redis

## TL;DR;

```console
helm install ks-test/redis
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-test/redis
```

The command deploys the standalone Redis chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the redis chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.redis.repository` | The image of Redis container | `redis`
`image.redis.tag` | The tag of the Redis image | `5.0.5-alpine`
`image.redis.pullPolicy` | The pull policy of the Redis image | `IfNotPresent`
`config` | Custom configurations for redis.conf | `none`
`password` | The password to interact with Redis | `none`
`service.type` | The service type, can be `ClusterIP`, or `NodePort` | `ClusterIP`
`service.port` | The service port within the pod container | `6379`