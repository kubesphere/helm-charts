---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Using the GitLab-Shell chart

The `gitlab-shell` sub-chart provides an SSH server configured for Git SSH access to GitLab.

## Requirements

This chart depends on access to the Workhorse services, either as part of the
complete GitLab chart or provided as an external service reachable from the Kubernetes
cluster this chart is deployed onto.

## Design Choices

In order to easily support SSH replicas, and avoid using shared storage for the SSH
authorized keys, we are using the SSH [AuthorizedKeysCommand](https://man.openbsd.org/sshd_config#AuthorizedKeysCommand)
to authenticate against GitLab's authorized keys endpoint. As a result, we don't persist
or update the AuthorizedKeys file within these pods.

## Configuration

The `gitlab-shell` chart is configured in two parts: [external services](#external-services),
and [chart settings](#chart-settings). The port exposed through Ingress is configured
with `global.shell.port`, and defaults to `22`. The Service's external port is also
controlled by `global.shell.port`.

## Installation command line options

| Parameter                | Default        | Description                              |
| ------------------------ | -------------- | ---------------------------------------- |
| `annotations`            |                | Pod annotations                          |
| `config.loginGraceTime`  | `120`          | Specifies amount of time athat the server will disconnect after if the user has not successfully logged in |
| `config.maxStartups.full`  | `100`     | SSHd refuse probability will increase linearly and all unauthenticated connection attempts would be refused when unauthenticated connections number will reach specified number |
| `config.maxStartups.rate`  | `30`      | SSHd will refuse connections with specified probability when there would be too many unauthenticated connections (optional) |
| `config.maxStartups.start` | `10`      | SSHd will refuse connection attempts with some probability if there are currently more than the specified number of unauthenticated connections (optional) |
| `deployment.livenessProbe.initialDelaySeconds` | 10 | Delay before liveness probe is initiated |
| `deployment.livenessProbe.periodSeconds`  | 10 | How often to perform the liveness probe |
| `deployment.livenessProbe.timeoutSeconds` | 3 | When the liveness probe times out |
| `deployment.livenessProbe.successThreshold` | 1 | Minimum consecutive successes for the liveness probe to be considered successful after having failed |
| `deployment.livenessProbe.failureThreshold` | 3 | Minimum consecutive failures for the liveness probe to be considered failed after having succeeded |
| `enabled`                | `true`         | Shell enable flag                        |
| `extraContainers`        |                | List of extra containers to include      |
| `extraInitContainers`    |                | List of extra init containers to include |
| `extraVolumeMounts`      |                | List of extra volumes mounts to do       |
| `extraVolumes`           |                | List of extra volumes to create          |
| `extraEnv`               |                | List of extra environment variables to expose |
| `hpa.targetAverageValue` | `100m`         | Set the autoscaling target value         |
| `image.pullPolicy`       | `Always`       | Shell image pull policy                  |
| `image.pullSecrets`      |                | Secrets for the image repository         |
| `image.repository`       | `registry.com/gitlab-org/build/cng/gitlab-shell` | Shell image repository |
| `image.tag`              | `latest`       | Shell image tag                          |
| `init.image.repository`  |                | initContainer image                      |
| `init.image.tag`         |                | initContainer image tag                  |
| `replicaCount`           | `1`            | Shell replicas                           |
| `service.externalTrafficPolicy` | `Cluster` | Shell service external traffic policy (Cluster or Local)  |
| `service.internalPort`   | `2222`         | Shell internal port                      |
| `service.nodePort`       |                | Sets shell nodePort if set               |
| `service.name`           | `gitlab-shell` | Shell service name                       |
| `service.type`           | `ClusterIP`    | Shell service type                       |
| `service.loadBalancerIP` |                | IP address to assign to LoadBalancer (if supported) |
| `service.loadBalancerSourceRanges` |      | List of IP CIDRs allowed access to LoadBalancer (if supported)  |
| `securityContext.fsGroup` | `1000`      |Group ID under which the pod should be started |
| `securityContext.runAsUser` | `1000`      |User ID under which the pod should be started  |
| `tolerations`            | `[]`           | Toleration labels for pod assignment     |
| `workhorse.serviceName`    | `webservice`      | Workhorse service name (by default, Workhorse is a part of the webservice Pods / Service)                   |

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
  repository: my.shell.repository
  tag: latest
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

`annotations` allows you to add annotations to the GitLab Shell pods.

Below is an example use of `annotations`

```yaml
annotations:
  kubernetes.io/example-annotation: annotation-value
```

## External Services

This chart should be attached the Workhorse service.

### Workhorse

```yaml
workhorse:
  host: workhorse.example.com
  serviceName: webservice
  port: 8181
```

| Name          | Type    | Default   | Description |
|:--------------|:-------:|:----------|:------------|
| `host`        | String  |           | The hostname of the Workhorse server. This can be omitted in lieu of `serviceName`. |
| `port`        | Integer | `8181`    | The port on which to connect to the Workhorse server.|
| `serviceName` | String  | `webservice` | The name of the `service` which is operating the Workhorse server. By default, Workhorse is a part of the webservice Pods / Service. If this is present, and `host` is not, the chart will template the hostname of the service (and current `.Release.Name`) in place of the `host` value. This is convenient when using Workhorse as a part of the overall GitLab chart. |

## Chart Settings

The following values are used to configure the GitLab Shell Pods.

### hostKeys.secret

The name of the Kubernetes `secret` to grab the SSH host keys from. The keys in the
secret must start with the key names `ssh_host_` in order to be used by GitLab Shell.

### authToken

GitLab Shell uses an Auth Token in its communication with Workhorse. Share the token
with GitLab Shell and Workhorse using a shared Secret.

```yaml
authToken:
 secret: gitlab-shell-secret
 key: secret
```

| Name               | Type    | Default | Description |
|:-------------------|:-------:|:--------|:------------|
| `authToken.key`    | String  |         | The name of the key in the above secret that contains the auth token. |
| `authToken.secret` | String  |         | The name of the Kubernetes `Secret` to pull from. |

### LoadBalancer Service

If the `service.type` is set to `LoadBalancer`, you can optionally specify `service.loadBalancerIP` to create
the `LoadBalancer` with a user-specified IP (if your cloud provider supports it).

You can also optionally specify a list of `service.loadBalancerSourceRanges` to restrict
the CIDR ranges that can access the `LoadBalancer` (if your cloud provider supports it).

Additional information about the `LoadBalancer` service type can be found in
[the Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer)

```yaml
service:
  type: LoadBalancer
  loadBalancerIP: 1.2.3.4
  loadBalancerSourceRanges:
  - 5.6.7.8/32
  - 10.0.0.0/8
```
