# porter chart

---

## Introduction

Porter is an open source load balancer designed for bare metal Kubernetes clusters. It's implemented by physical switch, and uses BGP and ECMP to achieve the best performance and high availability.

---

## Prerequistes

- kubernetes version:1.17.3

- helm3

---

## Installing the Chart

> Note: this chart is only supported by helm3

```bash
helm repo add test https://charts.kubesphere.io/test
help repo update
helm install porter test/porter
```

## Uninstalling the Chart

To uninstall/delete the `porter` release:

```bash
helm del porter
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration


The following table lists the configurable parameters of the MSOMS chart and their default values.

| Parameter | Description  | Default |
| -----------------------    | -----------------------| -----------------------|
| `manager.image.repository`| `manager` image name.        | kubesphere/porter |
| `manager.image.tag`       | `manager` image tag.         | v0.3.1  |
| `manager.image.pullPolicy`| `manager` image pull Policy. | IfNotPresent  |
| `manager.resources`| manager pod resource requests & limits | limits:</br>&nbsp;&nbsp;cpu: 100m</br>&nbsp;&nbsp;memory: 30Mi</br>requests:</br>&nbsp;&nbsp;cpu: 100m</br>&nbsp;&nbsp;memory: 20Mi   |
| `manager.nodeSelector`| node labels for pod assignment,porter manager pod must be deployed in master |  `node-role.kubernetes.io/master: ""`  |
| `manager.terminationGracePeriodSeconds`| Data termination grace period (seconds) |   10  |
| `manager.tolerations`| resource tolerations for manager pod | - key: CriticalAddonsOnly</br>&nbsp;&nbsp;operator: Exists</br>- effect: NoSchedule</br>&nbsp;&nbsp;key: node-role.kubernetes.io/master</br> |
| `agent.image.repository`|  `agent` image name. | kubesphere/porter  |
| `agent.image.tag`| `agent.image.tag` | v0.3.1 |
| `agent.image.pullPolicy`| `agent` image pull Policy. | IfNotPresent  |
| `agent.resources`| manager pod resource requests & limits | limits:</br>&nbsp;&nbsp;cpu: 100m</br>&nbsp;&nbsp;memory: 30Mi</br>requests:</br>&nbsp;&nbsp;cpu: 100m</br>&nbsp;&nbsp;memory: 20Mi  |

```bash
helm install porter \
-n kube-system \
test/porter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install porter -n kube-system -f service.yaml test/porter
```
