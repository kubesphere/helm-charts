# vSphere TMM Helm Charts
WARNING: v1.x.x of this Helm chart contains breaking changes!
While it is possible to deploy CPI directly with this chart, beware of the resulting naming and complexity.

The Namespace for vSphere CSI in upstream has changed with version 2.3.0, its is now `vmware-system-csi` instead of `kube-system`. This chart should be unaffected, as you can freely change the Namespace.

## Adding this helm repository

To add the helm repository for the vSphere CSI driver, run the following commands:

```bash
helm repo add vsphere-tmm https://vsphere-tmm.github.io/helm-charts
helm search repo vsphere-csi
```

`values.yaml` files for the charts can be found in the `charts/[chartname]` directories.

## TL;DR

```console
$ helm repo add vsphere-tmm https://vsphere-tmm.github.io/helm-charts
$ helm install my-release vsphere-tmm/vsphere-csi
```

## Introduction

Unofficial repository of helm charts created by the vSphere Technical Marketing team.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release vsphere-tmm/vsphere-csi
```

The command deploys vsphere-csi on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                               | Value        |
| ------------------------- | --------------------------------------------------------- | ------------ |
| `global.imageRegistry`    | Global Docker image registry                              | `nil`        |
| `global.imagePullSecrets` | Global Docker registry secret names as an array           | `undefined`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)              | `nil`        |
| `global.logLevel`         | Global logLevel for CSI, can be PRODUCTION or DEVELOPMENT | `PRODUCTION` |


### global.config Global Configuration for both CPI and CSI

| Name                                           | Description                                                                                                        | Value       |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----------- |
| `global.config.csidriver.enabled`              | Enable CSI-Driver                                                                                                  | `true`      |
| `global.config.storageclass.enabled`           | Enable creation of StorageClass                                                                                    | `false`     |
| `global.config.storageclass.storagepolicyname` | Set storagePolicyName                                                                                              | `""`        |
| `global.config.storageclass.expansion`         | Enable VolumeExpansion for storageclass, see https://vsphere-csi-driver.sigs.k8s.io/features/volume_expansion.html | `false`     |
| `global.config.storageclass.default`           | Make created storageClass default                                                                                  | `false`     |
| `global.config.netconfig`                      | Configre Network config for Filebased-Volumes                                                                      | `undefined` |


### global.config.global Global properties in this section will be used for all specified vCenters unless overriden in VirtualCenter section.

| Name                                | Description                                                       | Value       |
| ----------------------------------- | ----------------------------------------------------------------- | ----------- |
| `global.config.global.port`         | Default port to use if not specified different for vCenter        | `443`       |
| `global.config.global.insecureFlag` | Weather to default to insecure connections to vCenters by default | `true`      |
| `global.config.vcenter`             | vCenter-specifc confguration                                      | `undefined` |
| `global.config.labels`              | Used to configure Toplogy-awareness                               | `undefined` |


### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `nil`           |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |
| `commonLabels`      | Labels to add to all deployed objects              | `undefined`     |
| `commonAnnotations` | Annotations to add to all deployed objects         | `undefined`     |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `undefined`     |


### Traffic Exposure Parameters

| Name                               | Description                                           | Value       |
| ---------------------------------- | ----------------------------------------------------- | ----------- |
| `service.type`                     | vsphere-csi service type                              | `ClusterIP` |
| `service.port`                     | vsphere-csi service HTTP port                         | `80`        |
| `service.httpsPort`                | vsphere-csi service HTTPS port                        | `443`       |
| `service.nodePorts.http`           | Node port for HTTP                                    | `nil`       |
| `service.nodePorts.https`          | Node port for HTTPS                                   | `nil`       |
| `service.clusterIP`                | vsphere-csi service Cluster IP                        | `nil`       |
| `service.loadBalancerIP`           | vsphere-csi service Load Balancer IP                  | `nil`       |
| `service.loadBalancerSourceRanges` | vsphere-csi service Load Balancer sources             | `undefined` |
| `service.externalTrafficPolicy`    | vsphere-csi service external traffic policy           | `Cluster`   |
| `service.annotations`              | Additional custom annotations for vsphere-csi service | `undefined` |


### controller Parameters

| Name                                                          | Description                                                                                            | Value                                       |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------- |
| `controller.name`                                             | name used for the deployment, if unset defaults to "{{ template "common.names.fullname" . }}"          | `vsphere-csi-controller`                    |
| `controller.config`                                           | block to freely define options for the controller configmap"          | see values.yaml                   |
| `controller.image.registry`                                   | controller image registry                                                                              | `gcr.io`                                    |
| `controller.image.repository`                                 | controller image repository                                                                            | `cloud-provider-vsphere/csi/release/driver` |
| `controller.image.tag`                                        | controller image tag (immutable tags are recommended)                                                  | `v2.3.0`                                    |
| `controller.image.pullPolicy`                                 | controller image pull policy                                                                           | `IfNotPresent`                              |
| `controller.image.pullSecrets`                                | controller image pull secrets                                                                          | `undefined`                                 |
| `controller.image.debug`                                      | Enable image debug mode                                                                                | `false`                                     |
| `controller.global.extraEnvVars`                              | Array with extra environment variables for all controller containers                                   | `undefined`                                 |
| `controller.global.extraEnvVarsCM`                            | Name of existing ConfigMap containing extra env vars for all controller containers                     | `nil`                                       |
| `controller.global.extraEnvVarsSecret`                        | Name of existing Secret containing extra env vars for all controller containers                        | `nil`                                       |
| `controller.global.extraVolumeMounts`                         | Optionally specify extra list of additional volumeMounts for all controller containers                 | `undefined`                                 |
| `controller.resizer.image.registry`                           | controller.resizer image registry                                                                      | `quay.io`                                   |
| `controller.resizer.image.repository`                         | controller.resizer image repository                                                                    | `k8scsi/csi-resizer`                        |
| `controller.resizer.image.tag`                                | controller.resizer image tag (immutable tags are recommended)                                          | `v1.1.0`                                    |
| `controller.resizer.image.pullPolicy`                         | controller.resizer image pull policy                                                                   | `IfNotPresent`                              |
| `controller.resizer.image.pullSecrets`                        | controller.resizer image pull secrets                                                                  | `undefined`                                 |
| `controller.resizer.image.debug`                              | Enable image debug mode                                                                                | `false`                                     |
| `controller.resizer.lifecycleHooks`                           | for the controller.resizer container(s) to automate configuration before or after startup              | `undefined`                                 |
| `controller.extraEnvVars`                                     | Array with extra environment variables to add to controller.resizer nodes                              | `undefined`                                 |
| `controller.resizer.containerSecurityContext.enabled`         | Enabled controller.resizer containers' Security Context                                                | `false`                                     |
| `controller.resizer.containerSecurityContext.runAsUser`       | Set controller.resizer containers' Security Context runAsUser                                          | `1001`                                      |
| `controller.resizer.command`                                  | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.resizer.args`                                     | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.resizer.extraEnvVars`                             | Array with extra environment variables to add to controller.resizer nodes                              | `undefined`                                 |
| `controller.resizer.extraEnvVarsCM`                           | Name of existing ConfigMap containing extra env vars for controller.resizer nodes                      | `nil`                                       |
| `controller.resizer.extraEnvVarsSecret`                       | Name of existing Secret containing extra env vars for controller.resizer nodes                         | `nil`                                       |
| `controller.resizer.resources.limits`                         | The resources limits for the controller.resizer containers                                             | `undefined`                                 |
| `controller.resizer.resources.requests`                       | The requested resources for the controller.resizer containers                                          | `undefined`                                 |
| `controller.resizer.livenessProbe.enabled`                    | Enable livenessProbe on controller.resizer nodes                                                       | `false`                                     |
| `controller.resizer.livenessProbe.initialDelaySeconds`        | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `controller.resizer.livenessProbe.periodSeconds`              | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `controller.resizer.livenessProbe.timeoutSeconds`             | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `controller.resizer.livenessProbe.failureThreshold`           | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `controller.resizer.livenessProbe.successThreshold`           | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `controller.resizer.readinessProbe.enabled`                   | Enable readinessProbe on controller.resizer nodes                                                      | `false`                                     |
| `controller.resizer.readinessProbe.initialDelaySeconds`       | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.resizer.readinessProbe.periodSeconds`             | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.resizer.readinessProbe.timeoutSeconds`            | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.resizer.readinessProbe.failureThreshold`          | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.resizer.readinessProbe.successThreshold`          | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.resizer.customLivenessProbe`                      | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.resizer.customReadinessProbe`                     | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.resizer.extraVolumeMounts`                        | Optionally specify extra list of additional volumeMounts for the controller.resizer container(s)       | `undefined`                                 |
| `controller.attacher.image.registry`                          | controller.attacher image registry                                                                     | `k8s.gcr.io`                                |
| `controller.attacher.image.repository`                        | controller.attacher image repository                                                                   | `sig-storage/csi-attacher`                  |
| `controller.attacher.image.tag`                               | controller.attacher image tag (immutable tags are recommended)                                         | `v3.2.0`                                    |
| `controller.attacher.image.pullPolicy`                        | controller.attacher image pull policy                                                                  | `IfNotPresent`                              |
| `controller.attacher.image.pullSecrets`                       | controller.attacher image pull secrets                                                                 | `undefined`                                 |
| `controller.attacher.image.debug`                             | Enable image debug mode                                                                                | `false`                                     |
| `controller.attacher.lifecycleHooks`                          | for the controller.attacher container(s) to automate configuration before or after startup             | `undefined`                                 |
| `controller.extraEnvVars`                                     | Array with extra environment variables to add to controller.attacher nodes                             | `undefined`                                 |
| `controller.attacher.containerSecurityContext.enabled`        | Enabled controller.attacher containers' Security Context                                               | `false`                                     |
| `controller.attacher.containerSecurityContext.runAsUser`      | Set controller.attacher containers' Security Context runAsUser                                         | `1001`                                      |
| `controller.attacher.command`                                 | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.attacher.args`                                    | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.attacher.extraEnvVars`                            | Array with extra environment variables to add to controller.attacher nodes                             | `undefined`                                 |
| `controller.attacher.extraEnvVarsCM`                          | Name of existing ConfigMap containing extra env vars for controller.attacher nodes                     | `nil`                                       |
| `controller.attacher.extraEnvVarsSecret`                      | Name of existing Secret containing extra env vars for controller.attacher nodes                        | `nil`                                       |
| `controller.attacher.resources.limits`                        | The resources limits for the controller.attacher containers                                            | `undefined`                                 |
| `controller.attacher.resources.requests`                      | The requested resources for the controller.attacher containers                                         | `undefined`                                 |
| `controller.attacher.livenessProbe.enabled`                   | Enable livenessProbe on controller.attacher nodes                                                      | `false`                                     |
| `controller.attacher.livenessProbe.initialDelaySeconds`       | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `controller.attacher.livenessProbe.periodSeconds`             | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `controller.attacher.livenessProbe.timeoutSeconds`            | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `controller.attacher.livenessProbe.failureThreshold`          | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `controller.attacher.livenessProbe.successThreshold`          | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `controller.attacher.readinessProbe.enabled`                  | Enable readinessProbe on controller.attacher nodes                                                     | `false`                                     |
| `controller.attacher.readinessProbe.initialDelaySeconds`      | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.attacher.readinessProbe.periodSeconds`            | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.attacher.readinessProbe.timeoutSeconds`           | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.attacher.readinessProbe.failureThreshold`         | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.attacher.readinessProbe.successThreshold`         | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.attacher.customLivenessProbe`                     | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.attacher.customReadinessProbe`                    | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.attacher.extraVolumeMounts`                       | Optionally specify extra list of additional volumeMounts for the controller.attacher container(s)      | `undefined`                                 |
| `controller.livenessprobe.image.registry`                     | controller.livenessprobe image registry                                                                | `quay.io`                                   |
| `controller.livenessprobe.image.repository`                   | controller.livenessprobe image repository                                                              | `k8scsi/livenessprobe`                      |
| `controller.livenessprobe.image.tag`                          | controller.livenessprobe image tag (immutable tags are recommended)                                    | `v2.2.0`                                    |
| `controller.livenessprobe.image.pullPolicy`                   | controller.livenessprobe image pull policy                                                             | `IfNotPresent`                              |
| `controller.livenessprobe.image.pullSecrets`                  | controller.livenessprobe image pull secrets                                                            | `undefined`                                 |
| `controller.livenessprobe.image.debug`                        | Enable image debug mode                                                                                | `false`                                     |
| `controller.livenessprobe.lifecycleHooks`                     | for the controller.livenessprobe container(s) to automate configuration before or after startup        | `undefined`                                 |
| `controller.livenessprobe.extraEnvVars`                       | Array with extra environment variables to add to controller.livenessprobe nodes                        | `undefined`                                 |
| `controller.livenessprobe.containerSecurityContext.enabled`   | Enabled controller.livenessprobe containers' Security Context                                          | `false`                                     |
| `controller.livenessprobe.containerSecurityContext.runAsUser` | Set controller.livenessprobe containers' Security Context runAsUser                                    | `1001`                                      |
| `controller.livenessprobe.command`                            | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.livenessprobe.args`                               | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.livenessprobe.extraEnvVars`                       | Array with extra environment variables to add to controller.livenessprobe nodes                        | `undefined`                                 |
| `controller.livenessprobe.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for controller.livenessprobe nodes                | `nil`                                       |
| `controller.livenessprobe.extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for controller.livenessprobe nodes                   | `nil`                                       |
| `controller.livenessprobe.resources.limits`                   | The resources limits for the controller.livenessprobe containers                                       | `undefined`                                 |
| `controller.livenessprobe.resources.requests`                 | The requested resources for the controller.livenessprobe containers                                    | `undefined`                                 |
| `controller.livenessprobe.livenessProbe.enabled`              | Enable livenessProbe on controller.livenessprobe nodes                                                 | `false`                                     |
| `controller.livenessprobe.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `controller.livenessprobe.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `controller.livenessprobe.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `controller.livenessprobe.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `controller.livenessprobe.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `controller.livenessprobe.readinessProbe.enabled`             | Enable readinessProbe on controller.livenessprobe nodes                                                | `false`                                     |
| `controller.livenessprobe.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.livenessprobe.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.livenessprobe.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.livenessprobe.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.livenessprobe.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.livenessprobe.customLivenessProbe`                | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.livenessprobe.customReadinessProbe`               | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.livenessprobe.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the controller.livenessprobe container(s) | `undefined`                                 |
| `controller.syncer.image.registry`                            | controller.syncer image registry                                                                       | `gcr.io`                                    |
| `controller.syncer.image.repository`                          | controller.syncer image repository                                                                     | `cloud-provider-vsphere/csi/release/syncer` |
| `controller.syncer.image.tag`                                 | controller.syncer image tag (immutable tags are recommended)                                           | `v2.3.0`                                    |
| `controller.syncer.image.pullPolicy`                          | controller.syncer image pull policy                                                                    | `IfNotPresent`                              |
| `controller.syncer.image.pullSecrets`                         | controller.syncer image pull secrets                                                                   | `undefined`                                 |
| `controller.syncer.image.debug`                               | Enable image debug mode                                                                                | `false`                                     |
| `controller.syncer.lifecycleHooks`                            | for the controller.syncer container(s) to automate configuration before or after startup               | `undefined`                                 |
| `controller.syncer.extraEnvVars`                              | Array with extra environment variables to add to controller.syncer nodes                               | `undefined`                                 |
| `controller.syncer.containerSecurityContext.enabled`          | Enabled controller.syncer containers' Security Context                                                 | `false`                                     |
| `controller.syncer.containerSecurityContext.runAsUser`        | Set controller.syncer containers' Security Context runAsUser                                           | `1001`                                      |
| `controller.syncer.command`                                   | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.syncer.args`                                      | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.syncer.extraEnvVars`                              | Array with extra environment variables to add to controller.syncer nodes                               | `undefined`                                 |
| `controller.syncer.extraEnvVarsCM`                            | Name of existing ConfigMap containing extra env vars for controller.syncer nodes                       | `nil`                                       |
| `controller.syncer.extraEnvVarsSecret`                        | Name of existing Secret containing extra env vars for controller.syncer nodes                          | `nil`                                       |
| `controller.syncer.resources.limits`                          | The resources limits for the controller.syncer containers                                              | `undefined`                                 |
| `controller.syncer.resources.requests`                        | The requested resources for the controller.syncer containers                                           | `undefined`                                 |
| `controller.syncer.livenessProbe.enabled`                     | Enable livenessProbe on controller.syncer nodes                                                        | `false`                                     |
| `controller.syncer.livenessProbe.initialDelaySeconds`         | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `controller.syncer.livenessProbe.periodSeconds`               | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `controller.syncer.livenessProbe.timeoutSeconds`              | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `controller.syncer.livenessProbe.failureThreshold`            | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `controller.syncer.livenessProbe.successThreshold`            | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `controller.syncer.readinessProbe.enabled`                    | Enable readinessProbe on controller.syncer nodes                                                       | `false`                                     |
| `controller.syncer.readinessProbe.initialDelaySeconds`        | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.syncer.readinessProbe.periodSeconds`              | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.syncer.readinessProbe.timeoutSeconds`             | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.syncer.readinessProbe.failureThreshold`           | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.syncer.readinessProbe.successThreshold`           | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.syncer.customLivenessProbe`                       | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.syncer.customReadinessProbe`                      | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.syncer.extraVolumeMounts`                         | Optionally specify extra list of additional volumeMounts for the controller.syncer container(s)        | `undefined`                                 |
| `controller.provisioner.image.registry`                       | controller.provisioner image registry                                                                  | `k8s.gcr.io`                                |
| `controller.provisioner.image.repository`                     | controller.provisioner image repository                                                                | `sig-storage/csi-provisioner`               |
| `controller.provisioner.image.tag`                            | controller.provisioner image tag (immutable tags are recommended)                                      | `v2.2.0`                                    |
| `controller.provisioner.image.pullPolicy`                     | controller.provisioner image pull policy                                                               | `IfNotPresent`                              |
| `controller.provisioner.image.pullSecrets`                    | controller.provisioner image pull secrets                                                              | `undefined`                                 |
| `controller.provisioner.image.debug`                          | Enable image debug mode                                                                                | `false`                                     |
| `controller.provisioner.lifecycleHooks`                       | for the controller.provisioner container(s) to automate configuration before or after startup          | `undefined`                                 |
| `controller.provisioner.extraEnvVars`                         | Array with extra environment variables to add to controller.provisioner nodes                          | `undefined`                                 |
| `controller.provisioner.containerSecurityContext.enabled`     | Enabled controller.provisioner containers' Security Context                                            | `false`                                     |
| `controller.provisioner.containerSecurityContext.runAsUser`   | Set controller.provisioner containers' Security Context runAsUser                                      | `1001`                                      |
| `controller.provisioner.command`                              | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.provisioner.args`                                 | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.provisioner.extraEnvVars`                         | Array with extra environment variables to add to controller.provisioner nodes                          | `undefined`                                 |
| `controller.provisioner.extraEnvVarsCM`                       | Name of existing ConfigMap containing extra env vars for controller.provisioner nodes                  | `nil`                                       |
| `controller.provisioner.extraEnvVarsSecret`                   | Name of existing Secret containing extra env vars for controller.provisioner nodes                     | `nil`                                       |
| `controller.provisioner.resources.limits`                     | The resources limits for the controller.provisioner containers                                         | `undefined`                                 |
| `controller.provisioner.resources.requests`                   | The requested resources for the controller.provisioner containers                                      | `undefined`                                 |
| `controller.provisioner.livenessProbe.enabled`                | Enable livenessProbe on controller.provisioner nodes                                                   | `false`                                     |
| `controller.provisioner.livenessProbe.initialDelaySeconds`    | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `controller.provisioner.livenessProbe.periodSeconds`          | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `controller.provisioner.livenessProbe.timeoutSeconds`         | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `controller.provisioner.livenessProbe.failureThreshold`       | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `controller.provisioner.livenessProbe.successThreshold`       | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `controller.provisioner.readinessProbe.enabled`               | Enable readinessProbe on controller.provisioner nodes                                                  | `false`                                     |
| `controller.provisioner.readinessProbe.initialDelaySeconds`   | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.provisioner.readinessProbe.periodSeconds`         | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.provisioner.readinessProbe.timeoutSeconds`        | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.provisioner.readinessProbe.failureThreshold`      | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.provisioner.readinessProbe.successThreshold`      | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.provisioner.customLivenessProbe`                  | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.provisioner.customReadinessProbe`                 | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.provisioner.extraVolumeMounts`                    | Optionally specify extra list of additional volumeMounts for the controller.provisioner container(s)   | `undefined`                                 |
| `controller.replicaCount`                                     | Number of controller replicas to deploy                                                                | `1`                                         |
| `controller.livenessProbe.enabled`                            | Enable livenessProbe on controller nodes                                                               | `true`                                      |
| `controller.livenessProbe.httpGet.path`                       | Path for HTTPGet Livenessprobe                                                                         | `/healthz`                                  |
| `controller.livenessProbe.httpGet.port`                       | Path for HTTPGet Livenessprobe                                                                         | `healthz`                                   |
| `controller.livenessProbe.initialDelaySeconds`                | Initial delay seconds for livenessProbe                                                                | `25`                                        |
| `controller.livenessProbe.periodSeconds`                      | Period seconds for livenessProbe                                                                       | `5`                                         |
| `controller.livenessProbe.timeoutSeconds`                     | Timeout seconds for livenessProbe                                                                      | `3`                                         |
| `controller.livenessProbe.failureThreshold`                   | Failure threshold for livenessProbe                                                                    | `3`                                         |
| `controller.readinessProbe.enabled`                           | Enable readinessProbe on controller nodes                                                              | `false`                                     |
| `controller.readinessProbe.initialDelaySeconds`               | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `controller.readinessProbe.periodSeconds`                     | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `controller.readinessProbe.timeoutSeconds`                    | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `controller.readinessProbe.failureThreshold`                  | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `controller.readinessProbe.successThreshold`                  | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `controller.customLivenessProbe`                              | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `controller.customReadinessProbe`                             | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `controller.dnsPolicy`                                        | set DNS Policy                                                                                         | `Default`                                   |
| `controller.resources.limits`                                 | The resources limits for the controller containers                                                     | `undefined`                                 |
| `controller.resources.requests`                               | The requested resources for the controller containers                                                  | `undefined`                                 |
| `controller.podSecurityContext.enabled`                       | Enabled controller pods' Security Context                                                              | `false`                                     |
| `controller.podSecurityContext.fsGroup`                       | Set controller pod's Security Context fsGroup                                                          | `1001`                                      |
| `controller.containerSecurityContext.enabled`                 | Enabled controller containers' Security Context                                                        | `false`                                     |
| `controller.containerSecurityContext.runAsUser`               | Set controller containers' Security Context runAsUser                                                  | `1001`                                      |
| `controller.existingConfigmap`                                | The name of an existing ConfigMap with your custom configuration for controller                        | `nil`                                       |
| `controller.command`                                          | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `controller.args`                                             | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `controller.hostAliases`                                      | controller pods host aliases                                                                           | `undefined`                                 |
| `controller.podLabels`                                        | Extra labels for controller pods                                                                       | `undefined`                                 |
| `controller.podAnnotations`                                   | Annotations for controller pods                                                                        | `undefined`                                 |
| `controller.podAffinityPreset`                                | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`         | `""`                                        |
| `controller.podAntiAffinityPreset`                            | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`    | `soft`                                      |
| `controller.nodeAffinityPreset.type`                          | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`   | `""`                                        |
| `controller.nodeAffinityPreset.key`                           | Node label key to match. Ignored if `controller.affinity` is set                                       | `""`                                        |
| `controller.nodeAffinityPreset.values`                        | Node label values to match. Ignored if `controller.affinity` is set                                    | `undefined`                                 |
| `controller.affinity`                                         | Affinity for controller pods assignment                                                                | `undefined`                                 |
| `controller.nodeSelector`                                     | Node labels for controller pods assignment                                                             | `nil`                                       |
| `controller.tolerations`                                      | Tolerations for controller pods assignment                                                             | `[]`                                        |
| `controller.updateStrategy.type`                              | controller statefulset strategy type                                                                   | `RollingUpdate`                             |
| `controller.priorityClassName`                                | controller pods' priorityClassName                                                                     | `""`                                        |
| `controller.lifecycleHooks`                                   | for the controller container(s) to automate configuration before or after startup                      | `undefined`                                 |
| `controller.extraEnvVars`                                     | Array with extra environment variables to add to controller nodes                                      | `undefined`                                 |
| `controller.extraEnvVarsCM`                                   | Name of existing ConfigMap containing extra env vars for controller nodes                              | `nil`                                       |
| `controller.extraEnvVarsSecret`                               | Name of existing Secret containing extra env vars for controller nodes                                 | `nil`                                       |
| `controller.extraVolumes`                                     | Optionally specify extra list of additional volumes for the controller pod(s)                          | `undefined`                                 |
| `controller.extraVolumeMounts`                                | Optionally specify extra list of additional volumeMounts for the controller container(s)               | `undefined`                                 |
| `controller.sidecars`                                         | Add additional sidecar containers to the controller pod(s)                                             | `undefined`                                 |
| `controller.initContainers`                                   | Add additional init containers to the controller pod(s)                                                | `undefined`                                 |
| `controller.serviceAccount.create`                            | Specifies whether a ServiceAccount should be created                                                   | `true`                                      |
| `controller.serviceAccount.name`                              | The name of the ServiceAccount to use.                                                                 | `""`                                        |
| `node.name`                                                   | name used for the demonset, if unset defaults to "{{ template "common.names.fullname" . }}"            | `vsphere-csi-controller`                    |
| `node.image.registry`                                         | node image registry                                                                                    | `gcr.io`                                    |
| `node.image.repository`                                       | node image repository                                                                                  | `cloud-provider-vsphere/csi/release/driver` |
| `node.image.tag`                                              | node image tag (immutable tags are recommended)                                                        | `v2.3.0`                                    |
| `node.image.pullPolicy`                                       | node image pull policy                                                                                 | `IfNotPresent`                              |
| `node.image.pullSecrets`                                      | node image pull secrets                                                                                | `undefined`                                 |
| `node.image.debug`                                            | Enable image debug mode                                                                                | `false`                                     |
| `node.registrar.image.registry`                               | node image registry                                                                                    | `quay.io`                                   |
| `node.registrar.image.repository`                             | node image repository                                                                                  | `k8scsi/csi-node-driver-registrar`          |
| `node.registrar.image.tag`                                    | node image tag (immutable tags are recommended)                                                        | `v2.1.0`                                    |
| `node.registrar.image.pullPolicy`                             | node image pull policy                                                                                 | `IfNotPresent`                              |
| `node.registrar.image.pullSecrets`                            | node image pull secrets                                                                                | `undefined`                                 |
| `node.registrar.image.debug`                                  | Enable image debug mode                                                                                | `false`                                     |
| `node.registrar.lifecycleHooks`                               | for the node.registrar container(s) to automate configuration before or after startup                  | `undefined`                                 |
| `node.registrar.extraEnvVars`                                 | Array with extra environment variables to add to node.registrar nodes                                  | `undefined`                                 |
| `node.registrar.containerSecurityContext.enabled`             | Enabled node.registrar containers' Security Context                                                    | `false`                                     |
| `node.registrar.command`                                      | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `node.registrar.args`                                         | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `node.registrar.extraEnvVars`                                 | Array with extra environment variables to add to node.registrar nodes                                  | `undefined`                                 |
| `node.registrar.extraEnvVarsCM`                               | Name of existing ConfigMap containing extra env vars for node.registrar nodes                          | `nil`                                       |
| `node.registrar.extraEnvVarsSecret`                           | Name of existing Secret containing extra env vars for node.registrar nodes                             | `nil`                                       |
| `node.registrar.resources.limits`                             | The resources limits for the node.registrar containers                                                 | `undefined`                                 |
| `node.registrar.resources.requests`                           | The requested resources for the node.registrar containers                                              | `undefined`                                 |
| `node.registrar.livenessProbe.enabled`                        | Enable livenessProbe on node.registrar nodes                                                           | `true`                                      |
| `node.registrar.livenessProbe.httpGet.path`                   | Path for HTTPGet Livenessprobe                                                                         | `/healthz`                                  |
| `node.registrar.livenessProbe.httpGet.port`                   | Path for HTTPGet Livenessprobe                                                                         | `healthz`                                   |
| `node.registrar.livenessProbe.initialDelaySeconds`            | Initial delay seconds for livenessProbe                                                                | `5`                                         |
| `node.registrar.livenessProbe.timeoutSeconds`                 | Timeout seconds for livenessProbe                                                                      | `5`                                         |
| `node.registrar.readinessProbe.enabled`                       | Enable readinessProbe on node.registrar nodes                                                          | `false`                                     |
| `node.registrar.readinessProbe.initialDelaySeconds`           | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `node.registrar.readinessProbe.periodSeconds`                 | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `node.registrar.readinessProbe.timeoutSeconds`                | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `node.registrar.readinessProbe.failureThreshold`              | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `node.registrar.readinessProbe.successThreshold`              | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `node.registrar.customLivenessProbe`                          | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `node.registrar.customReadinessProbe`                         | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `node.registrar.extraVolumeMounts`                            | Optionally specify extra list of additional volumeMounts for the node.registrar container(s)           | `undefined`                                 |
| `node.livenessprobe.image.registry`                           | node image registry                                                                                    | `quay.io`                                   |
| `node.livenessprobe.image.repository`                         | node image repository                                                                                  | `k8scsi/livenessprobe`                      |
| `node.livenessprobe.image.tag`                                | node image tag (immutable tags are recommended)                                                        | `v2.2.0`                                    |
| `node.livenessprobe.image.pullPolicy`                         | node image pull policy                                                                                 | `IfNotPresent`                              |
| `node.livenessprobe.image.pullSecrets`                        | node image pull secrets                                                                                | `undefined`                                 |
| `node.livenessprobe.image.debug`                              | Enable image debug mode                                                                                | `false`                                     |
| `node.livenessprobe.lifecycleHooks`                           | for the node.livenessprobes container(s) to automate configuration before or after startup             | `undefined`                                 |
| `node.livenessprobe.extraEnvVars`                             | Array with extra environment variables to add to node.livenessprobes nodes                             | `undefined`                                 |
| `node.livenessprobe.containerSecurityContext.enabled`         | Enabled node.livenessprobes containers' Security Context                                               | `false`                                     |
| `node.livenessprobe.command`                                  | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `node.livenessprobe.args`                                     | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `node.livenessprobe.extraEnvVars`                             | Array with extra environment variables to add to node.livenessprobes nodes                             | `undefined`                                 |
| `node.livenessprobe.extraEnvVarsCM`                           | Name of existing ConfigMap containing extra env vars for node.livenessprobes nodes                     | `nil`                                       |
| `node.livenessprobe.extraEnvVarsSecret`                       | Name of existing Secret containing extra env vars for node.livenessprobes nodes                        | `nil`                                       |
| `node.livenessprobe.resources.limits`                         | The resources limits for the node.livenessprobes containers                                            | `undefined`                                 |
| `node.livenessprobe.resources.requests`                       | The requested resources for the node.livenessprobes containers                                         | `undefined`                                 |
| `node.livenessprobe.livenessProbe.enabled`                    | Enable livenessProbe on node.livenessprobes nodes                                                      | `false`                                     |
| `node.livenessprobe.livenessProbe.initialDelaySeconds`        | Initial delay seconds for livenessProbe                                                                | `foo`                                       |
| `node.livenessprobe.livenessProbe.periodSeconds`              | Period seconds for livenessProbe                                                                       | `bar`                                       |
| `node.livenessprobe.livenessProbe.timeoutSeconds`             | Timeout seconds for livenessProbe                                                                      | `foo`                                       |
| `node.livenessprobe.livenessProbe.failureThreshold`           | Failure threshold for livenessProbe                                                                    | `bar`                                       |
| `node.livenessprobe.livenessProbe.successThreshold`           | Success threshold for livenessProbe                                                                    | `foo`                                       |
| `node.livenessprobe.readinessProbe.enabled`                   | Enable readinessProbe on node.livenessprobes nodes                                                     | `false`                                     |
| `node.livenessprobe.readinessProbe.initialDelaySeconds`       | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `node.livenessprobe.readinessProbe.periodSeconds`             | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `node.livenessprobe.readinessProbe.timeoutSeconds`            | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `node.livenessprobe.readinessProbe.failureThreshold`          | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `node.livenessprobe.readinessProbe.successThreshold`          | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `node.livenessprobe.customLivenessProbe`                      | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `node.livenessprobe.customReadinessProbe`                     | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `node.livenessprobe.extraVolumeMounts`                        | Optionally specify extra list of additional volumeMounts for the node.livenessprobes container(s)      | `undefined`                                 |
| `node.livenessProbe.enabled`                                  | Enable livenessProbe on node nodes                                                                     | `true`                                      |
| `node.livenessProbe.httpGet.path`                             | Path for HTTPGet Livenessprobe                                                                         | `/healthz`                                  |
| `node.livenessProbe.httpGet.port`                             | Path for HTTPGet Livenessprobe                                                                         | `healthz`                                   |
| `node.livenessProbe.initialDelaySeconds`                      | Initial delay seconds for livenessProbe                                                                | `10`                                        |
| `node.livenessProbe.periodSeconds`                            | Period seconds for livenessProbe                                                                       | `5`                                         |
| `node.livenessProbe.timeoutSeconds`                           | Timeout seconds for livenessProbe                                                                      | `5`                                         |
| `node.livenessProbe.failureThreshold`                         | Failure threshold for livenessProbe                                                                    | `3`                                         |
| `node.readinessProbe.enabled`                                 | Enable readinessProbe on node nodes                                                                    | `false`                                     |
| `node.readinessProbe.initialDelaySeconds`                     | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `node.readinessProbe.periodSeconds`                           | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `node.readinessProbe.timeoutSeconds`                          | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `node.readinessProbe.failureThreshold`                        | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `node.readinessProbe.successThreshold`                        | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `node.customLivenessProbe`                                    | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `node.customReadinessProbe`                                   | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `node.resources.limits`                                       | The resources limits for the node containers                                                           | `undefined`                                 |
| `node.resources.requests`                                     | The requested resources for the node containers                                                        | `undefined`                                 |
| `node.hostNetwork`                                            | set use of hostNetwork for node containers                                                             | `true`                                      |
| `node.dnsPolicy`                                              | set DNS Policy                                                                                         | `ClusterFirstWithHostNet`                   |
| `node.podSecurityContext.enabled`                             | Enabled node pods' Security Context                                                                    | `false`                                     |
| `node.podSecurityContext.fsGroup`                             | Set node pod's Security Context fsGroup                                                                | `1001`                                      |
| `node.containerSecurityContext.enabled`                       | Enabled node containers' Security Context                                                              | `true`                                      |
| `node.containerSecurityContext.privileged`                    | Set node containers' Security Context privileged                                                       | `true`                                      |
| `node.containerSecurityContext.allowPrivilegeEscalation`      | Set node containers' Security Context allowPrivilegeEscalation                                         | `true`                                      |
| `node.existingConfigmap`                                      | The name of an existing ConfigMap with your custom configuration for node                              | `nil`                                       |
| `node.command`                                                | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `node.args`                                                   | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `node.hostAliases`                                            | node pods host aliases                                                                                 | `undefined`                                 |
| `node.podLabels`                                              | Extra labels for node pods                                                                             | `undefined`                                 |
| `node.podAnnotations`                                         | Annotations for node pods                                                                              | `undefined`                                 |
| `node.podAffinityPreset`                                      | Pod affinity preset. Ignored if `node.affinity` is set. Allowed values: `soft` or `hard`               | `""`                                        |
| `node.podAntiAffinityPreset`                                  | Pod anti-affinity preset. Ignored if `node.affinity` is set. Allowed values: `soft` or `hard`          | `soft`                                      |
| `node.nodeAffinityPreset.type`                                | Node affinity preset type. Ignored if `node.affinity` is set. Allowed values: `soft` or `hard`         | `""`                                        |
| `node.nodeAffinityPreset.key`                                 | Node label key to match. Ignored if `node.affinity` is set                                             | `""`                                        |
| `node.nodeAffinityPreset.values`                              | Node label values to match. Ignored if `node.affinity` is set                                          | `undefined`                                 |
| `node.affinity`                                               | Affinity for node pods assignment                                                                      | `undefined`                                 |
| `node.nodeSelector`                                           | Node labels for node pods assignment                                                                   | `undefined`                                 |
| `node.tolerations`                                            | Tolerations for node pods assignment                                                                   | `[]`                                        |
| `node.updateStrategy.type`                                    | node statefulset strategy type                                                                         | `RollingUpdate`                             |
| `node.priorityClassName`                                      | node pods' priorityClassName                                                                           | `""`                                        |
| `node.lifecycleHooks`                                         | for the node container(s) to automate configuration before or after startup                            | `undefined`                                 |
| `node.extraEnvVars`                                           | Array with extra environment variables to add to node nodes                                            | `undefined`                                 |
| `node.extraEnvVarsCM`                                         | Name of existing ConfigMap containing extra env vars for node nodes                                    | `nil`                                       |
| `node.extraEnvVarsSecret`                                     | Name of existing Secret containing extra env vars for node nodes                                       | `nil`                                       |
| `node.extraVolumes`                                           | Optionally specify extra list of additional volumes for the node pod(s)                                | `undefined`                                 |
| `node.extraVolumeMounts`                                      | Optionally specify extra list of additional volumeMounts for the node container(s)                     | `undefined`                                 |
| `node.sidecars`                                               | Add additional sidecar containers to the node pod(s)                                                   | `undefined`                                 |
| `node.initContainers`                                         | Add additional init containers to the node pod(s)                                                      | `undefined`                                 |
| `node.serviceAccount.create`                                  | Specifies whether a ServiceAccount should be created                                                   | `true`                                      |
| `node.serviceAccount.name`                                    | The name of the ServiceAccount to use.                                                                 | `""`                                        |
| `webhook.enabled`                                             | enable or disable webhook                                                                              | `false`                                     |
| `webhook.image.registry`                                      | webhook image registry                                                                                 | `gcr.io`                                    |
| `webhook.image.repository`                                    | webhook image repository                                                                               | `cloud-provider-vsphere/csi/release/syncer` |
| `webhook.image.tag`                                           | webhook image tag (immutable tags are recommended)                                                     | `v2.3.0`                                    |
| `webhook.image.pullPolicy`                                    | webhook image pull policy                                                                              | `IfNotPresent`                              |
| `webhook.image.pullSecrets`                                   | webhook image pull secrets                                                                             | `undefined`                                 |
| `webhook.image.debug`                                         | Enable image debug mode                                                                                | `false`                                     |
| `webhook.replicaCount`                                        | Number of webhook replicas to deploy                                                                   | `1`                                         |
| `webhook.livenessProbe.enabled`                               | Enable livenessProbe on webhook pods                                                                   | `false`                                     |
| `webhook.livenessProbe.httpGet.path`                          | Path for HTTPGet Livenessprobe                                                                         | `/healthz`                                  |
| `webhook.livenessProbe.httpGet.port`                          | Path for HTTPGet Livenessprobe                                                                         | `healthz`                                   |
| `webhook.livenessProbe.initialDelaySeconds`                   | Initial delay seconds for livenessProbe                                                                | `10`                                        |
| `webhook.livenessProbe.periodSeconds`                         | Period seconds for livenessProbe                                                                       | `5`                                         |
| `webhook.livenessProbe.timeoutSeconds`                        | Timeout seconds for livenessProbe                                                                      | `5`                                         |
| `webhook.livenessProbe.failureThreshold`                      | Failure threshold for livenessProbe                                                                    | `3`                                         |
| `webhook.readinessProbe.enabled`                              | Enable readinessProbe on webhook pods                                                                  | `false`                                     |
| `webhook.readinessProbe.initialDelaySeconds`                  | Initial delay seconds for readinessProbe                                                               | `foo`                                       |
| `webhook.readinessProbe.periodSeconds`                        | Period seconds for readinessProbe                                                                      | `bar`                                       |
| `webhook.readinessProbe.timeoutSeconds`                       | Timeout seconds for readinessProbe                                                                     | `foo`                                       |
| `webhook.readinessProbe.failureThreshold`                     | Failure threshold for readinessProbe                                                                   | `bar`                                       |
| `webhook.readinessProbe.successThreshold`                     | Success threshold for readinessProbe                                                                   | `foo`                                       |
| `webhook.customLivenessProbe`                                 | Custom livenessProbe that overrides the default one                                                    | `undefined`                                 |
| `webhook.customReadinessProbe`                                | Custom readinessProbe that overrides the default one                                                   | `undefined`                                 |
| `webhook.resources.limits`                                    | The resources limits for the webhook containers                                                        | `undefined`                                 |
| `webhook.resources.requests`                                  | The requested resources for the webhook containers                                                     | `undefined`                                 |
| `webhook.dnsPolicy`                                           | set DNS Policy                                                                                         | `Default`                                   |
| `webhook.podSecurityContext.enabled`                          | Enabled webhook pods' Security Context                                                                 | `false`                                     |
| `webhook.podSecurityContext.fsGroup`                          | Set webhook pod's Security Context fsGroup                                                             | `1001`                                      |
| `webhook.containerSecurityContext.enabled`                    | Enabled webhook containers' Security Context                                                           | `true`                                      |
| `webhook.containerSecurityContext.privileged`                 | Set webhook containers' Security Context privileged                                                    | `true`                                      |
| `webhook.containerSecurityContext.allowPrivilegeEscalation`   | Set webhook containers' Security Context allowPrivilegeEscalation                                      | `true`                                      |
| `webhook.existingConfigmap`                                   | The name of an existing ConfigMap with your custom configuration for webhook                           | `nil`                                       |
| `webhook.command`                                             | Override default container command (useful when using custom images)                                   | `undefined`                                 |
| `webhook.args`                                                | Override default container args (useful when using custom images)                                      | `[]`                                        |
| `webhook.hostAliases`                                         | webhook pods host aliases                                                                              | `undefined`                                 |
| `webhook.podLabels`                                           | Extra labels for webhook pods                                                                          | `undefined`                                 |
| `webhook.podAnnotations`                                      | Annotations for webhook pods                                                                           | `undefined`                                 |
| `webhook.podAffinityPreset`                                   | Pod affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`            | `""`                                        |
| `webhook.podAntiAffinityPreset`                               | Pod anti-affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`       | `soft`                                      |
| `webhook.nodeAffinityPreset.type`                             | webhook affinity preset type. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`   | `""`                                        |
| `webhook.nodeAffinityPreset.key`                              | webhook label key to match. Ignored if `webhook.affinity` is set                                       | `""`                                        |
| `webhook.nodeAffinityPreset.values`                           | webhook label values to match. Ignored if `webhook.affinity` is set                                    | `undefined`                                 |
| `webhook.affinity`                                            | Affinity for webhook pods assignment                                                                   | `undefined`                                 |
| `webhook.nodeSelector`                                        | Node labels for webhook pods assignment                                                                | `nil`                                       |
| `webhook.tolerations`                                         | Tolerations for webhook pods assignment                                                                | `[]`                                        |
| `webhook.updateStrategy.type`                                 | webhook statefulset strategy type                                                                      | `RollingUpdate`                             |
| `webhook.priorityClassName`                                   | webhook pods' priorityClassName                                                                        | `""`                                        |
| `webhook.lifecycleHooks`                                      | for the webhook container(s) to automate configuration before or after startup                         | `undefined`                                 |
| `webhook.extraEnvVars`                                        | Array with extra environment variables to add to webhook pods                                          | `undefined`                                 |
| `webhook.extraEnvVarsCM`                                      | Name of existing ConfigMap containing extra env vars for webhook pods                                  | `nil`                                       |
| `webhook.extraEnvVarsSecret`                                  | Name of existing Secret containing extra env vars for webhook pods                                     | `nil`                                       |
| `webhook.extraVolumes`                                        | Optionally specify extra list of additional volumes for the webhook pod(s)                             | `undefined`                                 |
| `webhook.extraVolumeMounts`                                   | Optionally specify extra list of additional volumeMounts for the webhook container(s)                  | `undefined`                                 |
| `webhook.sidecars`                                            | Add additional sidecar containers to the webhook pod(s)                                                | `undefined`                                 |
| `webhook.initContainers`                                      | Add additional init containers to the webhook pod(s)                                                   | `undefined`                                 |
| `webhook.serviceAccount.create`                               | Specifies whether a ServiceAccount should be created                                                   | `true`                                      |
| `webhook.serviceAccount.name`                                 | The name of the ServiceAccount to use.                                                                 | `""`                                        |


### Init Container Parameters

| Name | Description | Value |
| ---- | ----------- | ----- |


### Other Parameters

| Name          | Description                                        | Value  |
| ------------- | -------------------------------------------------- | ------ |
| `rbac.create` | Specifies whether RBAC resources should be created | `true` |


### Subchart parameters

| Name                  | Description                                                 | Value   |
| --------------------- | ----------------------------------------------------------- | ------- |
| `vsphere-cpi.enabled` | Specifies whether CPI subchart resources should be deployed | `false` |


## Configuration and installation details

A YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml vsphere-tmm/vsphere-csi
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
vsphere-csi:
  extraEnvVars:
    - name: LOG_LEVEL
      value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as vsphere-csi (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/vsphere-csi/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
