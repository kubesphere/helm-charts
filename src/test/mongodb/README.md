# MongoDB

## TL;DR;

```console
helm install ks-test/mongodb
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-test/mongodb
```

The command deploys the standalone MongoDB chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the mongodb chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.init.repository` | The image of init container | `mikefarah/yq`
`image.init.tag` | The tag of the init image | `2.4.1`
`image.init.pullPolicy` | The pull policy of the init image | `IfNotPresent`
`image.mongo.repository` | The image of MongoDB container | `mongodb`
`image.mongo.tag` | The tag of the MongoDB image | `5.0.5-alpine`
`image.mongo.pullPolicy` | The pull policy of the MongoDB image | `IfNotPresent`
`extraConfigurations` | Custom configurations for mongod.conf | `{}`
`rootUsername` | The username of root user to interact with MongoDB | `admin`
`rootPassword` | The password of root user to interact with MongoDB | `password`
`service.type` | The service type, can be `ClusterIP`, or `NodePort` | `ClusterIP`
`service.port` | The service port within the pod container | `27017`