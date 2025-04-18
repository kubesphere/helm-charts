# litmus

![Version: 2.1.3](https://img.shields.io/badge/Version-2.1.3-informational?style=flat-square) ![AppVersion: 2.1.1](https://img.shields.io/badge/AppVersion-2.1.1-informational?style=flat-square)

A Helm chart to install ChaosCenter

**Homepage:** <https://litmuschaos.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| rajdas98 | raj.das@mayadata.io |  |
| ispeakc0de | shubham.chaudhary@mayadata.io |  |
| jasstkn | jasssstkn@yahoo.com |  |

## Source Code

* <https://github.com/litmuschaos/litmus>

## Requirements

Kubernetes: `>=1.16.0-0`

## Installing the Chart

To install this chart with the release name `litmus-portal`:

```console
$ helm repo add main https://charts.kubesphere.io/main
$ helm install litmus-portal main/litmus
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminConfig.DBPASSWORD | string | `"1234"` |  |
| adminConfig.DBUSER | string | `"admin"` |  |
| adminConfig.DB_PORT | string | `"27017"` |  |
| adminConfig.DB_SERVER | string | `""` | leave empty if uses Mongo DB deployed by this chart |
| adminConfig.JWTSecret | string | `"litmus-portal@123"` |  |
| adminConfig.VERSION | string | `"2.2.0"` |  |
| customLabels | object | `{}` | Additional labels |
| image.imagePullSecrets | list | `[]` |  |
| image.imageRegistryName | string | `"litmuschaos"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.host.name | string | `""` | This is ingress hostname (ex: my-domain.com) |
| ingress.host.paths.backend | string | `"/backend/(.*)"` | You may need adapt the path depending your ingress-controller |
| ingress.host.paths.frontend | string | `"/(.*)"` | You may need adapt the path depending your ingress-controller |
| ingress.name | string | `"litmus-ingress"` |  |
| ingress.tls | list | `[]` |  |
| mongo.affinity | object | `{}` |  |
| mongo.containerPort | int | `27017` |  |
| mongo.customLabels | object | `{}` |  |
| mongo.image.pullPolicy | string | `"Always"` |  |
| mongo.image.repository | string | `"mongo"` |  |
| mongo.image.tag | string | `"4.2.8"` |  |
| mongo.livenessProbe.failureThreshold | int | `5` |  |
| mongo.livenessProbe.initialDelaySeconds | int | `30` |  |
| mongo.livenessProbe.periodSeconds | int | `10` |  |
| mongo.livenessProbe.successThreshold | int | `1` |  |
| mongo.livenessProbe.timeoutSeconds | int | `5` |  |
| mongo.nodeSelector | object | `{}` |  |
| mongo.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| mongo.persistence.size | string | `"20Gi"` |  |
| mongo.readinessProbe.initialDelaySeconds | int | `5` |  |
| mongo.readinessProbe.periodSeconds | int | `10` |  |
| mongo.readinessProbe.successThreshold | int | `1` |  |
| mongo.readinessProbe.timeoutSeconds | int | `1` |  |
| mongo.replicas | int | `1` |  |
| mongo.resources | object | `{}` |  |
| mongo.service.port | int | `27017` |  |
| mongo.service.targetPort | int | `27017` |  |
| mongo.service.type | string | `"ClusterIP"` |  |
| mongo.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| openshift.route.annotations | object | `{}` |  |
| openshift.route.enabled | bool | `false` |  |
| openshift.route.host | string | `""` |  |
| openshift.route.name | string | `"litmus-portal"` |  |
| portal.frontend.affinity | object | `{}` |  |
| portal.frontend.containerPort | int | `8080` |  |
| portal.frontend.customLabels | object | `{}` |  |
| portal.frontend.image.pullPolicy | string | `"Always"` |  |
| portal.frontend.image.repository | string | `"litmusportal-frontend"` |  |
| portal.frontend.image.tag | string | `"2.2.0"` |  |
| portal.frontend.livenessProbe.failureThreshold | int | `5` |  |
| portal.frontend.livenessProbe.initialDelaySeconds | int | `30` |  |
| portal.frontend.livenessProbe.periodSeconds | int | `10` |  |
| portal.frontend.livenessProbe.successThreshold | int | `1` |  |
| portal.frontend.livenessProbe.timeoutSeconds | int | `5` |  |
| portal.frontend.nodeSelector | object | `{}` |  |
| portal.frontend.readinessProbe.initialDelaySeconds | int | `5` |  |
| portal.frontend.readinessProbe.periodSeconds | int | `10` |  |
| portal.frontend.readinessProbe.successThreshold | int | `1` |  |
| portal.frontend.readinessProbe.timeoutSeconds | int | `1` |  |
| portal.frontend.replicas | int | `1` |  |
| portal.frontend.resources | object | `{}` |  |
| portal.frontend.service.port | int | `9091` |  |
| portal.frontend.service.targetPort | int | `8080` |  |
| portal.frontend.service.type | string | `"NodePort"` |  |
| portal.frontend.tolerations | list | `[]` |  |
| portal.frontend.updateStrategy | object | `{}` |  |
| portal.frontend.virtualService.enabled | bool | `false` |  |
| portal.frontend.virtualService.gateways | list | `[]` |  |
| portal.frontend.virtualService.hosts | list | `[]` |  |
| portal.server.affinity | object | `{}` |  |
| portal.server.authServer.containerPort | int | `3000` |  |
| portal.server.authServer.env.ADMIN_PASSWORD | string | `"litmus"` |  |
| portal.server.authServer.env.ADMIN_USERNAME | string | `"admin"` |  |
| portal.server.authServer.image.pullPolicy | string | `"Always"` |  |
| portal.server.authServer.image.repository | string | `"litmusportal-auth-server"` |  |
| portal.server.authServer.image.tag | string | `"2.2.0"` |  |
| portal.server.authServer.resources | object | `{}` |  |
| portal.server.customLabels | object | `{}` |  |
| portal.server.graphqlServer.containerPort | int | `8080` |  |
| portal.server.graphqlServer.genericEnv.AGENT_DEPLOYMENTS | string | `"[\"app=chaos-exporter\", \"name=chaos-operator\", \"app=event-tracker\", \"app=workflow-controller\"]"` |  |
| portal.server.graphqlServer.genericEnv.CONTAINER_RUNTIME_EXECUTOR | string | `"k8sapi"` |  |
| portal.server.graphqlServer.genericEnv.HUB_BRANCH_NAME | string | `"v2.1.x"` |  |
| portal.server.graphqlServer.genericEnv.SELF_CLUSTER | string | `"true"` |  |
| portal.server.graphqlServer.image.pullPolicy | string | `"Always"` |  |
| portal.server.graphqlServer.image.repository | string | `"litmusportal-server"` |  |
| portal.server.graphqlServer.image.tag | string | `"2.2.0"` |  |
| portal.server.graphqlServer.imageEnv.ARGO_WORKFLOW_CONTROLLER_IMAGE | string | `"workflow-controller:v2.11.0"` |  |
| portal.server.graphqlServer.imageEnv.ARGO_WORKFLOW_EXECUTOR_IMAGE | string | `"argoexec:v2.11.0"` |  |
| portal.server.graphqlServer.imageEnv.EVENT_TRACKER_IMAGE | string | `"litmusportal-event-tracker:2.2.0"` |  |
| portal.server.graphqlServer.imageEnv.LITMUS_CHAOS_EXPORTER_IMAGE | string | `"chaos-exporter:2.1.1"` |  |
| portal.server.graphqlServer.imageEnv.LITMUS_CHAOS_OPERATOR_IMAGE | string | `"chaos-operator:2.1.1"` |  |
| portal.server.graphqlServer.imageEnv.LITMUS_CHAOS_RUNNER_IMAGE | string | `"chaos-runner:2.1.1"` |  |
| portal.server.graphqlServer.imageEnv.SUBSCRIBER_IMAGE | string | `"litmusportal-subscriber:2.2.0"` |  |
| portal.server.graphqlServer.livenessProbe.failureThreshold | int | `5` |  |
| portal.server.graphqlServer.livenessProbe.initialDelaySeconds | int | `30` |  |
| portal.server.graphqlServer.livenessProbe.periodSeconds | int | `10` |  |
| portal.server.graphqlServer.livenessProbe.successThreshold | int | `1` |  |
| portal.server.graphqlServer.livenessProbe.timeoutSeconds | int | `5` |  |
| portal.server.graphqlServer.readinessProbe.initialDelaySeconds | int | `5` |  |
| portal.server.graphqlServer.readinessProbe.periodSeconds | int | `10` |  |
| portal.server.graphqlServer.readinessProbe.successThreshold | int | `1` |  |
| portal.server.graphqlServer.readinessProbe.timeoutSeconds | int | `1` |  |
| portal.server.graphqlServer.resources | object | `{}` |  |
| portal.server.nodeSelector | object | `{}` |  |
| portal.server.replicas | int | `1` |  |
| portal.server.service.authServer.port | int | `9003` |  |
| portal.server.service.authServer.targetPort | int | `3000` |  |
| portal.server.service.graphqlServer.port | int | `9002` |  |
| portal.server.service.graphqlServer.targetPort | int | `8080` |  |
| portal.server.service.type | string | `"NodePort"` |  |
| portal.server.serviceAccountName | string | `"litmus-server-account"` |  |
| portal.server.tolerations | list | `[]` |  |
| portal.server.updateStrategy | object | `{}` |  |
| portal.server.waitForMongodb.image.pullPolicy | string | `"Always"` |  |
| portal.server.waitForMongodb.image.repository | string | `"curl"` |  |
| portal.server.waitForMongodb.image.tag | string | `"latest"` |  |
| portalScope | string | `"cluster"` |  |
| upgradeAgent.affinity | object | `{}` |  |
| upgradeAgent.controlPlane.image.pullPolicy | string | `"Always"` |  |
| upgradeAgent.controlPlane.image.repository | string | `"upgrade-agent-cp"` |  |
| upgradeAgent.controlPlane.image.tag | string | `"ci"` |  |
| upgradeAgent.nodeSelector | object | `{}` |  |
| upgradeAgent.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
