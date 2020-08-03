---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Using the GitLab Webservice Chart

The `webservice` sub-chart provides the GitLab Rails webserver with two Webservice workers
per pod. (The minimum necessary for a single pod to be able to serve any web request in GitLab)

Currently the container used in the chart also includes a copy of GitLab Workhorse,
which we haven't split out yet.

## Requirements

This chart depends on Redis, PostgreSQL, Gitaly, and Registry services, either as
part of the complete GitLab chart or provided as external services reachable from
the Kubernetes cluster this chart is deployed onto.

## Configuration

The `webservice` chart is configured as follows: [Global Settings](#global-settings),
[Ingress Settings](#ingress-settings), [External Services](#external-services), and
[Chart Settings](#chart-settings).

## Installation command line options

The table below contains all the possible chart configurations that can be supplied
to the `helm install` command using the `--set` flags.

| Parameter                        | Default               | Description                                    |
| -------------------------------- | --------------------- | ---------------------------------------------- |
| `annotations`                    |                       | Pod annotations                                |
| `deployment.livenessProbe.initialDelaySeconds`  | 20     | Delay before liveness probe is initiated       |
| `deployment.livenessProbe.periodSeconds`        | 60     | How often to perform the liveness probe        |
| `deployment.livenessProbe.timeoutSeconds`       | 30     | When the liveness probe times out              |
| `deployment.livenessProbe.successThreshold`     | 1      | Minimum consecutive successes for the liveness probe to be considered successful after having failed |
| `deployment.livenessProbe.failureThreshold`     | 3      | Minimum consecutive failures for the liveness probe to be considered failed after having succeeded |
| `deployment.readinessProbe.initialDelaySeconds` | 0      | Delay before readiness probe is initiated      |
| `deployment.readinessProbe.periodSeconds`       | 10     | How often to perform the readiness probe       |
| `deployment.readinessProbe.timeoutSeconds`      | 2      | When the readiness probe times out             |
| `deployment.readinessProbe.successThreshold`    | 1      | Minimum consecutive successes for the readiness probe to be considered successful after having failed |
| `deployment.readinessProbe.failureThreshold`    | 3      | Minimum consecutive failures for the readiness probe to be considered failed after having succeeded |
| `deployment.strategy`      | `{}`                  | Allows one to configure the update strategy used by the deployment. When not provided, the cluster default is used. |
| `enabled`                        | `true`                | Webservice enabled flag                           |
| `extraContainers`                |                       | List of extra containers to include            |
| `extraInitContainers`            |                       | List of extra init containers to include       |
| `extras.google_analytics_id`     | `nil`                 | Google Analytics Id for frontend               |
| `extraVolumeMounts`              |                       | List of extra volumes mountes to do            |
| `extraVolumes`                   |                       | List of extra volumes to create                |
| `extraEnv`                       |                       | List of extra environment variables to expose  |
| `gitlab.webservice.workhorse.image` | `registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ee` | Workhorse image repository |
| `gitlab.webservice.workhorse.tag`   |                       | Workhorse image tag                            |
| `hpa.targetAverageValue`         | `1`                   | Set the autoscaling target value               |
| `image.pullPolicy`               | `Always`              | Webservice image pull policy                      |
| `image.pullSecrets`              |                       | Secrets for the image repository               |
| `image.repository`               | `registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ee` | Webservice image repository |
| `image.tag`                      |                       | Webservice image tag                              |
| `init.image.repository`          |                       | initContainer image                            |
| `init.image.tag`                 |                       | initContainer image tag                        |
| `unicorn.memory.min`             | `1024`                | The minimum memory threshold (in megabytes) for the Unicorn worker killer |
| `unicorn.memory.max`             | `1280`                | The maximum memory threshold (in megabytes) for the Unicorn worker killer |
| `metrics.enabled`                | `true`                | Toggle Prometheus metrics exporter             |
| `minio.bucket`                   | `git-lfs`             | Name of storage bucket, when using MinIO       |
| `minio.port`                     | `9000`                | Port for MinIO service                         |
| `minio.serviceName`              | `minio-svc`           | Name of MinIO service                          |
| `monitoring.ipWhitelist`         | `[0.0.0.0/0]`         | List of IPs to whitelist for the monitoring endpoints |
| `monitoring.exporter.enabled`         | `false`          | Enable webserver to expose Prometheus metrics  |
| `monitoring.exporter.port`            | `8083`           | Port number to use for the metrics exporter    |
| `psql.password.key`              | `psql-password`       | Key to psql password in psql secret            |
| `psql.password.secret`           | `gitlab-postgres`     | psql secret name                               |
| `psql.port`                      |                       | Set PostgreSQL server port. Takes precedence over `global.psql.port` |
| `puma.disableWorkerKiller`       | `false`               | Disables Puma worker memory killer |
| `puma.workerMaxMemory`           | `1024`                | The maximum memory (in megabytes) for the Puma worker killer |
| `puma.threads.min`               | `4`                   | The minimum amount of Puma threads |
| `puma.threads.max`               | `4`                   | The maximum amount of Puma threads |
| `rack_attack.git_basic_auth`     | `{}`                  | See [GitLab documentation](https://docs.gitlab.com/ee/security/rack_attack.html) for details |
| `redis.serviceName`              | `redis`               | Redis service name                             |
| `registry.api.port`              | `5000`                | Registry port                                  |
| `registry.api.protocol`          | `http`                | Registry protocol                              |
| `registry.api.serviceName`       | `registry`            | Registry service name                          |
| `registry.enabled`               | `true`                | Add/Remove registry link in all projects menu  |
| `registry.tokenIssuer`           | `gitlab-issuer`       | Registry token issuer                          |
| `replicaCount`                   | `1`                   | Webservice number of replicas                     |
| `resources.requests.cpu`         | `300m`                | Webservice minimum cpu                            |
| `resources.requests.memory`      | `1.5G`                | Webservice minimum memory                         |
| `service.externalPort`           | `8080`                | Webservice exposed port                           |
| `securityContext.fsGroup`        | `1000`                | Group ID under which the pod should be started |
| `securityContext.runAsUser`      | `1000`                | User ID under which the pod should be started  |
| `service.internalPort`           | `8080`                | Webservice internal port                          |
| `service.type`                   | `ClusterIP`           | Webservice service type                           |
| `service.workhorseExternalPort`  | `8181`                | Workhorse exposed port                         |
| `service.workhorseInternalPort`  | `8181`                | Workhorse internal port                        |
| `shell.authToken.key`            | `secret`              | Key to shell token in shell secret             |
| `shell.authToken.secret`         | `gitlab-shell-secret` | Shell token secret                             |
| `shell.port`                     | `nil`                 | Port number to use in SSH URLs generated by UI |
| `shutdown.blackoutSeconds`       | `10`                  | Number of seconds to keep Webservice running after receiving shutdown |
| `tolerations`                    | `[]`                  | Toleration labels for pod assignment           |
| `trusted_proxies`                | `[]`                  | See [GitLab documentation](https://docs.gitlab.com/ee/install/installation.html#adding-your-trusted-proxies) for details |
| `workerProcesses`                | `2`                   | Webservice number of workers                      |
| `workhorse.livenessProbe.initialDelaySeconds`  | 20      | Delay before liveness probe is initiated       |
| `workhorse.livenessProbe.periodSeconds`        | 60      | How often to perform the liveness probe        |
| `workhorse.livenessProbe.timeoutSeconds`       | 30      | When the liveness probe times out              |
| `workhorse.livenessProbe.successThreshold`     | 1       | Minimum consecutive successes for the liveness probe to be considered successful after having failed |
| `workhorse.livenessProbe.failureThreshold`     | 3       | Minimum consecutive failures for the liveness probe to be considered failed after having succeeded |
| `workhorse.readinessProbe.initialDelaySeconds` | 0       | Delay before readiness probe is initiated      |
| `workhorse.readinessProbe.periodSeconds`       | 10      | How often to perform the readiness probe       |
| `workhorse.readinessProbe.timeoutSeconds`      | 2       | When the readiness probe times out             |
| `workhorse.readinessProbe.successThreshold`    | 1       | Minimum consecutive successes for the readiness probe to be considered successful after having failed |
| `workhorse.readinessProbe.failureThreshold`    | 3       | Minimum consecutive failures for the readiness probe to be considered failed after having succeeded |
| `webServer` | `puma` | Selects web server (Webservice/Puma) that would be used for request handling |
| `priorityClassName`                            | `""`    | Allow configuring pods `priorityClassName`, this is used to control pod priority in case of eviction |

## Chart configuration examples

### extraEnv

`extraEnv` allows you to expose additional environment variables in all containers in the pods.

Below is an example use of `extraEnv`:

```yaml
extraEnv:
  SOME_KEY: some_value
  SOME_OTHER_KEY: some_other_value
```

When the container is started, you can confirm that the enviornment variables are exposed:

```shell
env | grep SOME
SOME_KEY=some_value
SOME_OTHER_KEY=some_other_value
```

### image.pullSecrets

`pullSecrets` allows you to authenticate to a private registry to pull images for a pod.

Additional details about private registries and their authentication methods can be
found in [the Kubernetes documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

Below is an example use of `pullSecrets`:

```yaml
image:
  repository: my.webservice.repository
  pullPolicy: Always
  pullSecrets:
  - name: my-secret-name
  - name: my-secondary-secret-name
```

### tolerations

`tolerations` allow you schedule pods on tainted worker nodes

Below is an example use of `tolerations`:

```yaml
tolerations:
- key: "node_label"
  operator: "Equal"
  value: "true"
  effect: "NoSchedule"
- key: "node_label"
  operator: "Equal"
  value: "true"
  effect: "NoExecute"
```

### annotations

`annotations` allows you to add annotations to the Webservice pods. For example:

```yaml
annotations:
  kubernetes.io/example-annotation: annotation-value
```

### strategy

`deployment.strategy` allows you to change the deployment update strategy. It defines how the pods will be recreated when deployment is updated. When not provided, the cluster default is used.
For example, if you don't want to create extra pods when the rolling update starts and change max unavailable pods to 50%:

```yaml
deployment:
  strategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 50%
```

You can also change the type of update strategy to `Recreate`, but be careful as it will kill all pods before scheduling new ones, and the web UI will be unavailable until the new pods are started. In this case, you don't need to define `rollingUpdate`, only `type`:

```yaml
deployment:
  strategy:
    type: Recreate
```

For more details, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).

## Using the Community Edition of this chart

By default, the Helm charts use the Enterprise Edition of GitLab. If desired, you
can use the Community Edition instead. Learn more about the
[differences between the two](https://about.gitlab.com/install/ce-or-ee/).

In order to use the Community Edition, set `image.repository` to
`registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ce` and `workhorse.image`
to `registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce`.

## Global Settings

We share some common global settings among our charts. See the [Globals Documentation](../../globals.md)
for common configuration options, such as GitLab and Registry hostnames.

## Ingress Settings

| Name                                   | Type    | Default | Description |
|:-------------------------------------- |:-------:|:------- |:----------- |
| `ingress.annotations.*annotation-key*` | String  | (empty) | `annotation-key` is a string that will be used with the value as an annotation on every Ingress. For example: `ingress.annotations."nginx\.ingress\.kubernetes\.io/enable-access-log"=true`. |
| `ingress.enabled`                      | Boolean | `false` | Setting that controls whether to create Ingress objects for services that support them. When `false`, the `global.ingress.enabled` setting value is used. |
| `ingress.proxyBodySize`                | String  | `512m`  | [See Below](#proxybodysize). |
| `ingress.tls.enabled`                  | Boolean | `true`  | When set to `false`, you disable TLS for GitLab Webservice. This is mainly useful for cases in which you cannot use TLS termination at Ingress-level, like when you have a TLS-terminating proxy before the Ingress Controller. |
| `ingress.tls.secretName`               | String  | (empty) | The name of the Kubernetes TLS Secret that contains a valid certificate and key for the GitLab URL. When not set, the `global.ingress.tls.secretName` value is used instead. |

### proxyBodySize

`proxyBodySize` is used to set the NGINX proxy maximum body size. This is commonly
required to allow a larger Docker image than the default. As an alternative option,
you can set the body size with either of the following two parameters too:

- `gitlab.webservice.ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-body-size"`
- `global.ingress.annotations."nginx\.ingress\.kubernetes\.io/proxy-body-size"`

## Resources

### Unicorn Worker Killer memory settings

Memory thresholds for the [unicorn-worker-killer](https://docs.gitlab.com/ee/administration/operations/unicorn.html#unicorn-worker-killer)
can be customized using the `unicorn.memory.min` and `unicorn.memory.max` chart values. While the
default values are sane, you can increase (or lower) these values to fine-tune
them for your environment or troubleshoot performance issues.

NOTE: **Note:** These settings are effective on a _per process basis_, not for an entire Pod.

### Memory requests/limits

Each pod spawns an amount of workers equal to `workerProcesses`, who each use
some baseline amount of memory. The default memory requests and limits are based
on two workers at the [measured usage](https://gitlab.com/gitlab-org/omnibus-gitlab/-/merge_requests/3853)
of 750MB /worker, and a maximum usage of about 1G /worker. Thus, if you update
`workerProcesses`, you should update `requests.memory` and `limits.memory`
(if configured) accordingly. Note though, that as GitLab and usage changes, the
required resources will change as well.

Default:

```yaml
workerProcesses: 2
resources:
  requests:
    memory: 1.5G # = 2 * 750M
# limits:
#   memory: 2G   # = 2 * 1G
```

With 4 workers configured:

```yaml
workerProcesses: 4
resources:
  requests:
    memory: 3G   # = 4 * 750M
# limits:
#   memory: 4G   # = 4 * 1G
```

## External Services

### Redis

The Redis documentation has been consolidated in the [globals](../../globals.md#configure-redis-settings)
page. Please consult this page for the latest Redis configuration options.

### PostgreSQL

The PostgreSQL documentation has been consolidated in the [globals](../../globals.md#configure-postgresql-settings)
page. Please consult this page for the latest PostgreSQL configuration options.

### Gitaly

Gitaly is configured by [global settings](../../globals.md). Please see the
[Gitaly configuration documentation](../../globals.md#configure-gitaly-settings).

### MinIO

```yaml
minio:
  serviceName: 'minio-svc'
  port: 9000
```

| Name          | Type    | Default     | Description |
|:------------- |:-------:|:----------- |:----------- |
| `port`        | Integer | `9000`      | Port number to reach the MinIO `Service` on. |
| `serviceName` | String  | `minio-svc` | Name of the `Service` that is exposed by the MinIO pod. |

### Registry

```yaml
registry:
  host: registry.example.com
  port: 443
  api:
    protocol: http
    host: registry.example.com
    serviceName: registry
    port: 5000
  tokenIssuer: gitlab-issuer
  certificate:
    secret: gitlab-registry
    key: registry-auth.key
```

| Name                 | Type    | Default         | Description |
|:-------------------- |:-------:|:--------------- |:----------- |
| `api.host`           | String  |                 | The hostname of the Registry server to use. This can be omitted in lieu of `api.serviceName`. |
| `api.port`           | Integer | `5000`          | The port on which to connect to the Registry API. |
| `api.protocol`       | String  |                 | The protocol Webservice should use to reach the Registry API. |
| `api.serviceName`    | String  | `registry`      | The name of the `service` which is operating the Registry server. If this is present, and `api.host` is not, the chart will template the hostname of the service (and current `.Release.Name`) in place of the `api.host` value. This is convenient when using Registry as a part of the overall GitLab chart. |
| `certificate.key`    | String  |                 | The name of the `key` in the `Secret` which houses the certificate bundle that will be provided to the [registry](https://hub.docker.com/_/registry/) container as `auth.token.rootcertbundle`. |
| `certificate.secret` | String  |                 | The name of the [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that houses the certificate bundle to be used to verify the tokens created by the GitLab instance(s). |
| `host`               | String  |                 | The external hostname to use for providing Docker commands to users in the GitLab UI. Falls back to the value set in the `registry.hostname` template. Which determines the registry hostname based on the values set in `global.hosts`. See the [Globals Documentation](../../globals.md) for more information. |
| `port`               | Integer |                 | The external port used in the hostname. Using port `80` or `443` will result in the URLs being formed with `http`/`https`. Other ports will all use `http` and append the port to the end of hostname, for example `http://registry.example.com:8443`. |
| `tokenIssuer`        | String  | `gitlab-issuer` | The name of the auth token issuer. This must match the name used in the Registry's configuration, as it incorporated into the token when it is sent. The default of `gitlab-issuer` is the same default we use in the Registry chart. |

## Chart Settings

The following values are used to configure the Webservice Pods.

| Name              | Type    | Default | Description |
|:----------------- |:-------:|:------- |:----------- |
| `replicaCount`    | Integer | `1`     | The number of Webservice instances to create in the deployment. |
| `workerProcesses` | Integer | `2`     | The number of Webservice workers to run per pod. You must have at least `2` workers available in your cluster in order for GitLab to function properly. Note that increasing the `workerProcesses` will increase the memory required by approximately `400MB` per worker, so you should update the pod `resources` accordingly. |

### metrics.enabled

By default, each pod exposes a metrics endpoint at `/-/metrics`. Metrics are only
available when [GitLab Prometheus metrics](https://docs.gitlab.com/ee/administration/monitoring/prometheus/gitlab_metrics.html)
are enabled in the Admin area. When metrics are enabled, annotations are added to
each pod allowing a Prometheus server to discover and scrape the exposed metrics.

### GitLab Shell

GitLab Shell uses an Auth Token in its communication with Webservice. Share the token
with GitLab Shell and Webservice using a shared Secret.

```yaml
shell:
  authToken:
    secret: gitlab-shell-secret
    key: secret
  port:
```

| Name               | Type    | Default | Description |
|:------------------ |:-------:|:------- |:----------- |
| `authToken.key`    | String  |         | Defines the name of the key in the secret (below) that contains the authToken. |
| `authToken.secret` | String  |         | Defines the name of the Kubernetes `Secret` to pull from. |
| `port`             | Integer | `22`    | The port number to use in the generation of SSH URLs within the GitLab UI. Controlled by `global.shell.port`. |

### WebServer options

Current version of chart supports both Unicorn and Puma web servers.
Puma is the default, however you can switch to the Unicorn
server by setting `webServer: unicorn`

Puma unique options:

| Name               | Type    | Default | Description |
|:------------------ |:-------:|:------- |:----------- |
| `puma.workerMaxMemory`           | Integer | `1024`                | The maximum memory (in megabytes) for the Puma worker killer |
| `puma.threads.min`               | Integer | `4`                   | The minimum amount of Puma threads |
| `puma.threads.max`               | Integer | `4`                   | The maximum amount of Puma threads |
