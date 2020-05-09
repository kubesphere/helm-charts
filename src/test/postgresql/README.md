# PostgreSQL

## TL;DR;

```console
helm repo add ks-test https://charts.kubesphere.io/test
helm repo update
helm install ks-test/postgresql
```

## Installing

To install the chart with the release name `my-release`:

```console
helm install --name my-release ks-test/postgresql
```

The command deploys the PostgreSQL chart on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured during installation.

## Uninstalling

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the postgresql chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.postgres.repository` | The image of PostgreSQL container | `postgres`
`image.postgres.tag` | The tag of the PostgreSQL image | `12.0-alpine`
`image.postgres.pullPolicy` | The pull policy of the PostgreSQL image | `IfNotPresent`
`rootUsername` | The username of root user to interact with PostgreSQL | `postgres`
`rootPassword` | The password of root user to interact with PostgreSQL | `password`
`service.type` | The service type, can be `ClusterIP`, or `NodePort` | `ClusterIP`
`service.port` | The service port within the pod container | `5432`
