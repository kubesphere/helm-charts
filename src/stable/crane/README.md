# Crane
## TL;DR

```bash
helm install crane -n crane-system --create-namespace stable/crane
```

## Introduction

This chart bootstraps Crane Components on a Kubernetes cluster using the Helm package manager.

Learn more: https://github.com/gocrane/crane

## Prerequisites

* Kubernetes 1.18+
* Helm 3+

## Install Chart

```console
helm install crane -n crane-system --create-namespace stable/crane
```

See [configuration](#configuration) below.

See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation.

## Uninstall Chart

```console
helm uninstall crane -n crane-system
```

This removes all the Kubernetes components associated with the chart and deletes the release.

See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation.

## Configuration

The following table lists the configurable parameters of the Crane chart and their default values.

| Parameter                                                  | Description                               | Default                                         |
|:-----------------------------------------------------------|:------------------------------------------|:------------------------------------------------|
| `craned.image.repository`                                  | Image name of Craned                      | `docker.io/gocrane/craned`                |
| `craned.image.tag`                                         | Image tag of Craned. Optional, given app version of Helm chart is used by default | `` |
| `craned.image.pullPolicy`                                  | Image pullPolicy of Craned | `IfNotPresent` |
| `craned.replicaCount`                                      | Replica count of Craned | `1` |
| `craned.containerArgs`                                     | Container's command line arguments to pass to Craned | `{ "prometheus-address": "http://prometheus-server.crane-system.svc.cluster.local:8080", "feature-gates": "Analysis=true,TimeSeriesPrediction=true,Autoscaling=true", "v": "2"}` |
| `craned.podAnnotations`                                    | Pod annotations of Craned | `{}` |
| `craned.resources`                                         | Pod resources of Craned | `{}` |
| `craned.nodeSelector`                                      | Node selectors of Craned deployment| `{}` |
| `craned.tolerations`                                       | Tolerations of Craned deployment | `{}` |
| `craned.affinity`                                          | Affinity of Craned deployment | `{}` |
| `craned.nodeSelector`                                      | Node selectors of Craned | `{}` |
| `cranedDashboard.image.repository`                         | Image name of Craned Dashboard  | `docker.io/gocrane/craned` |
| `cranedDashboard.image.pullPolicy`                         | Image pullPolicy of Craned Dashboard | `IfNotPresent` |
| `scheduler.enable`                                         | Whether to deploy Scheduler               | true                |
| `scheduler.image.repository`                               | Image name of Scheduler.                  | `docker.io/gocrane/crane-scheduler` |
| `scheduler.image.tag`                                      | Image tag of Scheduler. Optional, given app version of Helm chart is used by default | `0.0.23` |
| `scheduler.replicaCount`                                   | Replica count of Scheduler | `1` |
| `controller.enable`                                        | Whether to deploy Scheduler-controller                   | true                |
| `controller.image.repository`                              | Image name of Scheduler-controller.  | `docker.io/gocrane/crane-scheduler-controller` |
| `controller.image.tag`                                     | Image tag of Scheduler-controller. Optional, given app version of Helm chart is used by default | `0.0.23` |
| `controller.replicaCount`                                  | Replica count of Scheduler-controller | `1` |
| `global.prometheusAddr`                                    | Address of Prometheus | `http://prometheus-server.crane-system.svc.cluster.local:8080` |
