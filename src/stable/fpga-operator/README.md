# InAccel FPGA Operator

Simplifying FPGA management in Kubernetes

## Installing the Chart

To install the chart with the release name `my-fpga-operator`:

```console
$ helm repo add inaccel https://setup.inaccel.com/helm
$ helm install my-fpga-operator inaccel/fpga-operator
```

These commands deploy InAccel FPGA Operator on the Kubernetes cluster in the
default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-fpga-operator` deployment:

```console
$ helm uninstall my-fpga-operator
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Parameters

The following table lists the configurable parameters of the InAccel FPGA
Operator chart and their default values.

| Parameter            | Default            |
| -------------------- | ------------------ |
| `coral.httpsProxy`   |                    |
| `coral.image`        | `inaccel/coral`    |
| `coral.logLevel`     | `info`             |
| `coral.port`         |                    |
| `coral.pullPolicy`   | `Always`           |
| `coral.resources`    |                    |
| `coral.tag`          | *APP VERSION*      |
| `daemon.debug`       | `false`            |
| `daemon.image`       | `inaccel/daemon`   |
| `daemon.pullPolicy`  |                    |
| `daemon.resources`   |                    |
| `daemon.tag`         | `latest`           |
| `driver.enabled`     | `true`             |
| `driver.image`       | `inaccel/driver`   |
| `driver.pullPolicy`  |                    |
| `driver.tag`         | `latest`           |
| `kubelet`            | `/var/lib/kubelet` |
| `license`            |                    |
| `mkrt.image`         | `inaccel/mkrt`     |
| `mkrt.pullPolicy`    |                    |
| `mkrt.tag`           | `latest`           |
| `monitor.image`      | `inaccel/monitor`  |
| `monitor.port`       |                    |
| `monitor.pullPolicy` | `Always`           |
| `monitor.resources`  |                    |
| `monitor.tag`        | *APP VERSION*      |
| `reef.debug`         | `false`            |
| `reef.image`         | `inaccel/reef`     |
| `reef.pullPolicy`    |                    |
| `reef.resources`     |                    |
| `reef.tag`           | `latest`           |
| `root.config`        | `/etc/inaccel`     |
| `root.state`         | `/var/lib/inaccel` |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
$ helm install my-fpga-operator -f values.yaml inaccel/fpga-operator
```

> **Tip**: You can use the default `values.yaml`
