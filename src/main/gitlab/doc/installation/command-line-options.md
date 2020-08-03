---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Installation command line options

The tables below contain all the possible charts configurations that can be supplied
to the `helm install` command using the `--set` flags.

The source of the default `values.yaml` file can be found [here](https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/values.yaml).
These contents change over releases, but you can use Helm itself to retrieve these on a per-version basis:

```shell
helm inspect values gitlab/gitlab
```

## Basic configuration

| Parameter                                      | Description                                                                                 | Default                                       |
|------------------------------------------------|---------------------------------------------------------------------------------------------|-----------------------------------------------|
| `gitlab.migrations.initialRootPassword.key`    | Key pointing to the root account password in the migrations secret                          | `password`                                    |
| `gitlab.migrations.initialRootPassword.secret` | Global name of the secret containing the root account password                              | `{Release.Name}-gitlab-initial-root-password` |
| `global.gitlab.license.key`                    | Key pointing to the Enterprise license in the license secret                                | `license`                                     |
| `global.gitlab.license.secret`                 | Global name of the secret containing the Enterprise license                                 | _none_                                        |
| `global.application.create`                    | Create an [Application resource](https://github.com/kubernetes-sigs/application) for GitLab | `false`                                       |
| `global.edition`                               | The edition of GitLab to install. Enterprise Edition (ee) or Community Edition (ce)         | `ee`                                          |
| `global.gitaly.enabled`                        | Gitaly enable flag                                                                          | true                                          |
| `global.hosts.domain`                          | Domain name that will be used for all publicly exposed services                             | Required                                      |
| `global.hosts.externalIP`                      | Static IP to assign to NGINX Ingress Controller                                             | Required                                      |
| `global.hosts.ssh`                             | Domain name that will be used for Git SSH access                                            | `gitlab.{global.hosts.domain}`                |
| `global.imagePullPolicy`                       | Set a default imagePullPolicy for all charts                                                | `IfNotPresent`                                |
| `global.minio.enabled`                         | MinIO enable flag                                                                           | `true`                                        |
| `global.psql.host`                             | Global hostname of an external psql, overrides subcharts' psql configuration                | _Uses in-cluster non-production PostgreSQL_   |
| `global.psql.password.key`                     | Key pointing to the psql password in the psql secret                                        | _Uses in-cluster non-production PostgreSQL_   |
| `global.psql.password.secret`                  | Global name of the secret containing the psql password                                      | _Uses in-cluster non-production PostgreSQL_   |
| `global.registry.bucket`                       | registry bucket name                                                                        | `registry`                                    |
| `global.service.annotations`                   | Annotations to add to every `Service`                                                       | {}                                            |
| `global.deployment.annotations`                | Annotations to add to every `Deployment`                                                    | {}                                            |
| `global.time_zone`                             | Global time zone                                                                            | UTC                                           |

## TLS configuration

| Parameter                               | Description                                                       | Default |
|-----------------------------------------|-------------------------------------------------------------------|---------|
| `certmanager-issuer.email`              | Email for Let's Encrypt account                                   | false   |
| `gitlab.webservice.ingress.tls.secretName` | Existing `Secret` containing TLS certificate and key for GitLab   | _none_  |
| `global.hosts.https`                    | Serve over https                                                  | true    |
| `global.ingress.configureCertmanager`   | Configure cert-manager to get certificates from Let's Encrypt     | true    |
| `global.ingress.tls.secretName`         | Existing `Secret` containing wildcard TLS certificate and key     | _none_  |
| `minio.ingress.tls.secretName`          | Existing `Secret` containing TLS certificate and key for MinIO    | _none_  |
| `registry.ingress.tls.secretName`       | Existing `Secret` containing TLS certificate and key for registry | _none_  |

## Outgoing Email configuration

| Parameter                         | Description                                                                             | Default               |
|-----------------------------------|-----------------------------------------------------------------------------------------|-----------------------|
| `global.email.display_name`       | Name that appears as the sender for emails from GitLab                                  | `GitLab`              |
| `global.email.from`               | Email address that appears as the sender for emails from GitLab                         | `gitlab@example.com`  |
| `global.email.reply_to`           | Reply-to email listed in emails from GitLab                                             | `noreply@example.com` |
| `global.email.smime.certName`     | Secret object key value for locating the S/MIME certificate file                        | tls.crt               |
| `global.email.smime.enabled`      | Add the S/MIME signatures to outgoing email                                             | false                 |
| `global.email.smime.keyName`      | Secret object key value for locating the S/MIME key file                                | tls.key               |
| `global.email.smime.secretName`   | Kubernetes Secret object to find the X.509 certificate ([S/MIME Cert](secrets.md#smime-certificate) for creation )  | ""                    |
| `global.email.subject_suffix`     | Suffix on the subject of all outgoing email from GitLab                                 | ""                    |
| `global.smtp.address`             | Hostname or IP of the remote mail server                                                | `smtp.mailgun.org`    |
| `global.smtp.authentication`      | Type of SMTP authentication ("plain", "login", "cram_md5", or "" for no authentication) | `plain`               |
| `global.smtp.domain`              | Optional HELO domain for SMTP                                                           | ""                    |
| `global.smtp.enabled`             | Enable outgoing email                                                                   | false                 |
| `global.smtp.openssl_verify_mode` | TLS verification mode ("none", "peer", or "ssl/tls")                                    | `peer`                |
| `global.smtp.password.key`        | Key in `global.smtp.password.secret` that contains the SMTP password                    | `password`            |
| `global.smtp.password.secret`     | Name of a `Secret` containing the SMTP password                                         | ""                    |
| `global.smtp.port`                | Port for SMTP                                                                           | `2525`                |
| `global.smtp.starttls_auto`       | Use STARTTLS if enabled on the mail server                                              | false                 |
| `global.smtp.tls`                 | Enables SMTP/TLS (SMTPS: SMTP over direct TLS connection)                               | _none_                |
| `global.smtp.user_name`           | Username for SMTP authentication https                                                  | ""                    |

## Incoming Email configuration

| Parameter                                        | Description                                                                                            | Default     |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------------|
| `global.appConfig.incomingEmail.address`         | The email address to reference the item being replied to (example: `gitlab-incoming+%{key}@gmail.com`) | empty       |
| `global.appConfig.incomingEmail.enabled`         | Enable incoming email                                                                                  | false       |
| `global.appConfig.incomingEmail.host`            | Host for IMAP                                                                                          | empty       |
| `global.appConfig.incomingEmail.idleTimeout`     | The IDLE command timeout                                                                               | `60`        |
| `global.appConfig.incomingEmail.mailbox`         | Mailbox where incoming mail will end up.                                                               | `inbox`     |
| `global.appConfig.incomingEmail.password.key`    | Key in `global.appConfig.incomingEmail.password.secret` that contains the IMAP password                | `password`  |
| `global.appConfig.incomingEmail.password.secret` | Name of a `Secret` containing the IMAP password                                                        | empty       |
| `global.appConfig.incomingEmail.port`            | Port for IMAP                                                                                          | `993`       |
| `global.appConfig.incomingEmail.ssl`             | Whether IMAP server uses SSL                                                                           | true        |
| `global.appConfig.incomingEmail.startTls`        | Whether IMAP server uses StartTLS                                                                      | false       |
| `global.appConfig.incomingEmail.user`            | Username for IMAP authentication                                                                       | empty       |
| `global.appConfig.incomingEmail.expungeDeleted`  | Whether to expunge (permanently remove) messages from the mailbox when they are deleted after delivery | false       |
| `global.appConfig.incomingEmail.logger.logPath`  | Path to write JSON structured logs to; set to "" to disable this logging                               | /dev/stdout |

## Service Desk Email configuration

As a requirement for Service Desk, the Incoming Mail must be [configured](#incoming-email-configuration).
Note that the email address for both Incoming Mail and Service Desk must use
[email sub-addressing](https://docs.gitlab.com/ee/administration/incoming_email.html#email-sub-addressing).
When setting the email addresses in each section the tag added to the username
must be `+%{key}`.

| Parameter                                        | Description                                                                                            | Default     |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------|-------------|
| `global.appConfig.serviceDeskEmail.address`         | The email address to reference the item being replied to (example: `project_contact+%{key}@gmail.com`) | empty       |
| `global.appConfig.serviceDeskEmail.enabled`         | Enable service desk email                                                                              | false       |
| `global.appConfig.serviceDeskEmail.host`            | Host for IMAP                                                                                          | empty       |
| `global.appConfig.serviceDeskEmail.idleTimeout`     | The IDLE command timeout                                                                               | `60`        |
| `global.appConfig.serviceDeskEmail.mailbox`         | Mailbox where service desk mail will end up.                                                           | `inbox`     |
| `global.appConfig.serviceDeskEmail.password.key`    | Key in `global.appConfig.serviceDeskEmail.password.secret` that contains the IMAP password             | `password`  |
| `global.appConfig.serviceDeskEmail.password.secret` | Name of a `Secret` containing the IMAP password                                                        | empty       |
| `global.appConfig.serviceDeskEmail.port`            | Port for IMAP                                                                                          | `993`       |
| `global.appConfig.serviceDeskEmail.ssl`             | Whether IMAP server uses SSL                                                                           | true        |
| `global.appConfig.serviceDeskEmail.startTls`        | Whether IMAP server uses StartTLS                                                                      | false       |
| `global.appConfig.serviceDeskEmail.user`            | Username for IMAP authentication                                                                       | empty       |
| `global.appConfig.serviceDeskEmail.expungeDeleted`  | Whether to expunge (permanently remove) messages from the mailbox when they are deleted after delivery | false       |
| `global.appConfig.serviceDeskEmail.logger.logPath`  | Path to write JSON structured logs to; set to "" to disable this logging                               | /dev/stdout |

## Default Project Features configuration

| Parameter                                                    | Description                               | Default |
|--------------------------------------------------------------|-------------------------------------------|---------|
| `global.appConfig.defaultProjectsFeatures.builds`            | Enable project builds                     | true    |
| `global.appConfig.defaultProjectsFeatures.containerRegistry` | Enable container registy project features | true    |
| `global.appConfig.defaultProjectsFeatures.issues`            | Enable project issues                     | true    |
| `global.appConfig.defaultProjectsFeatures.mergeRequests`     | Enable project merge requests             | true    |
| `global.appConfig.defaultProjectsFeatures.snippets`          | Enable project snippets                   | true    |
| `global.appConfig.defaultProjectsFeatures.wiki`              | Enable project wikis                      | true    |

## GitLab Shell

| Parameter                | Description                              | Default |
|--------------------------|------------------------------------------|---------|
| `global.shell.authToken` | Secret containing shared secret          |         |
| `global.shell.hostKeys`  | Secret containing SSH host keys          |         |
| `global.shell.port`      | Port number to expose on Ingress for SSH |         |

## RBAC Settings

| Parameter                              | Description                           | Default |
|----------------------------------------|---------------------------------------|---------|
| `certmanager.rbac.create`              | Create and use RBAC resources         | true    |
| `gitlab-runner.rbac.create`            | Create and use RBAC resources         | true    |
| `nginx-ingress.rbac.create`            | Create and use default RBAC resources | false   |
| `nginx-ingress.rbac.createClusterRole` | Create and use Cluster role           | false   |
| `nginx-ingress.rbac.createRole`        | Create and use namespaced role        | true    |
| `prometheus.rbac.create`               | Create and use RBAC resources         | true    |

## Advanced NGINX Ingress configuration

Prefix NGINX Ingress values with `nginx-ingress`. For example, set the controller image tag using `nginx-ingress.controller.image.tag`.

See [`nginx-ingress` chart](../charts/nginx/index.md).

## Advanced in-cluster Redis configuration

| Parameter                            | Description                                 | Default               |
|--------------------------------------|---------------------------------------------|-----------------------|
| `redis.install`                      | Install the `bitnami/redis` chart           | true                  |
| `redis.existingSecret`               | Specify the Secret for Redis servers to use | `gitlab-redis-secret` |
| `redis.existingSecretKey`            | Secret key where password is stored         | `redis-password`      |

Any additional configuration of the Redis service should use the configuration
settings from the [Redis chart](https://github.com/bitnami/charts/tree/master/bitnami/redis).

## Advanced registry configuration

| Parameter                            | Description                                    | Default              |
|--------------------------------------|------------------------------------------------|----------------------|
| `registry.authEndpoint`              | Auth endpoint                                  | Undefined by default |
| `registry.enabled`                   | Enable Docker registry                         | true                 |
| `registry.httpSecret`                | Https secret                                   |                      |
| `registry.minio.bucket`              | MinIO registry bucket name                     | `registry`           |
| `registry.service.annotations`       | Annotations to add to the `Service`            | {}                   |
| `registry.securityContext.fsGroup`   | Group ID under which the pod should be started | `1000`               |
| `registry.securityContext.runAsUser` | User ID under which the pod should be started  | `1000`               |
| `registry.tokenIssuer`               | JWT token issuer                               | `gitlab-issuer`      |
| `registry.tokenService`              | JWT token service                              | `container_registry` |

## Advanced MinIO configuration

| Parameter                            | Description                             | Default                        |
|--------------------------------------|-----------------------------------------|--------------------------------|
| `minio.defaultBuckets`               | MinIO default buckets                   | `[{"name": "registry"}]`       |
| `minio.image`                        | MinIO image                             | `minio/minio`                  |
| `minio.imagePullPolicy`              | MinIO image pull policy                 |                                |
| `minio.imageTag`                     | MinIO image tag                         | `RELEASE.2017-12-28T01-21-00Z` |
| `minio.minioConfig.browser`          | MinIO browser flag                      | `on`                           |
| `minio.minioConfig.domain`           | MinIO domain                            |                                |
| `minio.minioConfig.region`           | MinIO region                            | `us-east-1`                    |
| `minio.mountPath`                    | MinIO config file mount path            | `/export`                      |
| `minio.persistence.accessMode`       | MinIO persistence access mode           | `ReadWriteOnce`                |
| `minio.persistence.enabled`          | MinIO enable persistence flag           | true                           |
| `minio.persistence.matchExpressions` | MinIO label-expression matches to bind  |                                |
| `minio.persistence.matchLabels`      | MinIO label-value matches to bind       |                                |
| `minio.persistence.size`             | MinIO persistence volume size           | `10Gi`                         |
| `minio.persistence.storageClass`     | MinIO storageClassName for provisioning |                                |
| `minio.persistence.subPath`          | MinIO persistence volume mount path     |                                |
| `minio.persistence.volumeName`       | MinIO existing persistent volume name   |                                |
| `minio.replicas`                     | MinIO number of replicas                | `4`                            |
| `minio.resources.requests.cpu`       | MinIO minimum cpu requested             | `250m`                         |
| `minio.resources.requests.memory`    | MinIO minimum memory requested          | `256Mi`                        |
| `minio.service.annotations`          | Annotations to add to the `Service`     | {}                             |
| `minio.servicePort`                  | MinIO service port                      | `9000`                         |
| `minio.serviceType`                  | MinIO service type                      | `ClusterIP`                    |

## Advanced GitLab configuration

| Parameter                                                    | Description                                    | Default                                                          |
|--------------------------------------------------------------|------------------------------------------------|------------------------------------------------------------------|
| `gitlab-runner.checkInterval`                                | polling interval                               | `30s`                                                            |
| `gitlab-runner.concurrent`                                   | number of concurrent jobs                      | `20`                                                             |
| `gitlab-runner.install`                                      | install the `gitlab-runner` chart              | true                                                          |
| `gitlab-runner.image`                                        | runner image                                   | `gitlab/gitlab-runner:alpine-v10.5.0`                            |
| `gitlab-runner.imagePullPolicy`                              | image pull policy                              | `IfNotPresent`                                                   |
| `gitlab-runner.rbac.clusterWideAccess`                       | deploy containers of jobs cluster-wide         | false                                                            |
| `gitlab-runner.rbac.create`                                  | whether to create rbac service account         | true                                                             |
| `gitlab-runner.rbac.serviceAccountName`                      | name of the rbac service account to create     | `default`                                                        |
| `gitlab-runner.resources.limits.cpu`                         | runner resources                               |                                                                  |
| `gitlab-runner.resources.limits.memory`                      | runner resources                               |                                                                  |
| `gitlab-runner.resources.requests.cpu`                       | runner resources                               |                                                                  |
| `gitlab-runner.resources.requests.memory`                    | runner resources                               |                                                                  |
| `gitlab-runner.runners.build.cpuRequests`                    | build container limit                          |                                                                  |
| `gitlab-runner.runners.build.memoryLimit`                    | build container limit                          |                                                                  |
| `gitlab-runner.runners.build.memoryRequests`                 | build container limit                          |                                                                  |
| `gitlab-runner.runners.builds.cpuLimit`                      | build container limit                          |                                                                  |
| `gitlab-runner.runners.cache.cacheShared`                    | share the cache between runners                | true                                                             |
| `gitlab-runner.runners.cache.cacheType`                      | cache type                                     | `s3`                                                             |
| `gitlab-runner.runners.cache.s3BucketLocation`               | bucket region                                  | `us-east-1`                                                      |
| `gitlab-runner.runners.cache.s3BucketName`                   | name of the bucket                             | `runner-cache`                                                   |
| `gitlab-runner.runners.cache.s3CacheInsecure`                | use http                                       | false                                                            |
| `gitlab-runner.runners.cache.s3CachePath`                    | path in the bucket                             | `gitlab-runner`                                                  |
| `gitlab-runner.runners.cache.secretName`                     | secret to accesskey and secretkey from         | `gitlab-minio`                                                   |
| `gitlab-runner.runners.image`                                | default container image to use in builds       | `ubuntu:16.04`                                                   |
| `gitlab-runner.runners.imagePullSecrets`                     | imagePullSecrets                               | `[]`                                                             |
| `gitlab-runner.runners.namespace`                            | namespace to run jobs in                       | `default`                                                        |
| `gitlab-runner.runners.privileged`                           | run in privieleged mode,needed for `dind`      | false                                                            |
| `gitlab-runner.runners.service.cpuLimit`                     | service container limit                        |                                                                  |
| `gitlab-runner.runners.service.cpuRequests`                  | service container limit                        |                                                                  |
| `gitlab-runner.runners.service.memoryLimit`                  | service container limit                        |                                                                  |
| `gitlab-runner.runners.service.memoryRequests`               | service container limit                        |                                                                  |
| `gitlab-runner.unregisterRunners`                            | unregister all runners before termination      | true                                                             |
| `gitlab.geo-logcursor.securityContext.fsGroup`               | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.geo-logcursor.securityContext.runAsUser`             | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.gitaly.authToken.key`                                | Key to Gitaly token in the secret              | `token`                                                          |
| `gitlab.gitaly.authToken.secret`                             | Gitaly secret name                             | `{.Release.Name}-gitaly-secret`                                  |
| `gitlab.gitaly.image.pullPolicy`                             | Gitaly image pull policy                       |                                                         |
| `gitlab.gitaly.image.repository`                             | Gitaly image repository                        | `registry.gitlab.com/gitlab-org/build/cng/gitaly`                |
| `gitlab.gitaly.image.tag`                                    | Gitaly image tag                               | `latest`                                                         |
| `gitlab.gitaly.persistence.accessMode`                       | Gitaly persistence access mode                 | `ReadWriteOnce`                                                  |
| `gitlab.gitaly.persistence.enabled`                          | Gitaly enable persistence flag                 | true                                                             |
| `gitlab.gitaly.persistence.matchExpressions`                 | Label-expression matches to bind               |                                                                  |
| `gitlab.gitaly.persistence.matchLabels`                      | Label-value matches to bind                    |                                                                  |
| `gitlab.gitaly.persistence.size`                             | Gitaly persistence volume size                 | `50Gi`                                                           |
| `gitlab.gitaly.persistence.storageClass`                     | storageClassName for provisioning              |                                                                  |
| `gitlab.gitaly.persistence.subPath`                          | Gitaly persistence volume mount path           |                                                                  |
| `gitlab.gitaly.persistence.volumeName`                       | Existing persistent volume name                |                                                                  |
| `gitlab.gitaly.securityContext.fsGroup`                      | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.gitaly.securityContext.runAsUser`                    | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.gitaly.service.annotations`                          | Annotations to add to the `Service`            | `{}`                                                             |
| `gitlab.gitaly.service.externalPort`                         | Gitaly service exposed port                    | `8075`                                                           |
| `gitlab.gitaly.service.internalPort`                         | Gitaly internal port                           | `8075`                                                           |
| `gitlab.gitaly.service.name`                                 | Gitaly service name                            | `gitaly`                                                         |
| `gitlab.gitaly.service.type`                                 | Gitaly service type                            | `ClusterIP`                                                      |
| `gitlab.gitaly.serviceName`                                  | Gitaly service name                            | `gitaly`                                                         |
| `gitlab.gitaly.shell.authToken.key`                          | Shell key                                      | `secret`                                                         |
| `gitlab.gitaly.shell.authToken.secret`                       | Shell secret                                   | `{Release.Name}-gitlab-shell-secret`                             |
| `gitlab.gitlab-exporter.securityContext.fsGroup`             | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.gitlab-exporter.securityContext.runAsUser`           | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.gitlab-shell.authToken.key`                          | Shell auth secret key                          | `secret`                                                         |
| `gitlab.gitlab-shell.authToken.secret`                       | Shell auth secret                              | `{Release.Name}-gitlab-shell-secret`                             |
| `gitlab.gitlab-shell.enabled`                                | Shell enable flag                              | true                                                             |
| `gitlab.gitlab-shell.image.pullPolicy`                       | Shell image pull policy                        |                                                          |
| `gitlab.gitlab-shell.image.repository`                       | Shell image repository                         | `registry.gitlab.com/gitlab-org/build/cng/gitlab-shell`          |
| `gitlab.gitlab-shell.image.tag`                              | Shell image tag                                | `latest`                                                         |
| `gitlab.gitlab-shell.replicaCount`                           | Shell replicas                                 | `1`                                                              |
| `gitlab.gitlab-shell.securityContext.fsGroup`                | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.gitlab-shell.securityContext.runAsUser`              | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.gitlab-shell.service.annotations`                    | Annotations to add to the `Service`            | {}                                                               |
| `gitlab.gitlab-shell.service.internalPort`                   | Shell internal port                            | `2222`                                                           |
| `gitlab.gitlab-shell.service.name`                           | Shell service name                             | `gitlab-shell`                                                   |
| `gitlab.gitlab-shell.service.type`                           | Shell service type                             | `ClusterIP`                                                      |
| `gitlab.gitlab-shell.webservice.serviceName`                    | Webservice service name                           | `unicorn`                                                        |
| `gitlab.mailroom.securityContext.fsGroup`                    | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.mailroom.securityContext.runAsUser`                  | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.migrations.bootsnap.enabled`                         | Migrations Bootsnap enable flag                | true                                                             |
| `gitlab.migrations.enabled`                                  | Migrations enable flag                         | true                                                             |
| `gitlab.migrations.image.pullPolicy`                         | Migrations pull policy                         |                                                          |
| `gitlab.migrations.image.repository`                         | Migrations image repository                    | `registry.gitlab.com/gitlab-org/build/cng/gitlab-task_runner-ee`       |
| `gitlab.migrations.image.tag`                                | Migrations image tag                           | `latest`                                                         |
| `gitlab.migrations.psql.password.key`                        | key to psql password in psql secret            | `psql-password`                                                  |
| `gitlab.migrations.psql.password.secret`                     | psql secret                                    | `gitlab-postgres`                                                |
| `gitlab.migrations.psql.port`                                | Set PostgreSQL server port. Takes precedence over `global.psql.port`
|                                                                  |
| `gitlab.migrations.securityContext.fsGroup`                  | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.migrations.securityContext.runAsUser`                | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.sidekiq.concurrency`                                 | Sidekiq default concurrency                    | `10`                                                             |
| `gitlab.sidekiq.enabled`                                     | Sidekiq enabled flag                           | true                                                             |
| `gitlab.sidekiq.gitaly.authToken.key`                        | key to Gitaly token in Gitaly secret           | `token`                                                          |
| `gitlab.sidekiq.gitaly.authToken.secret`                     | Gitaly secret                                  | `{.Release.Name}-gitaly-secret`                                  |
| `gitlab.sidekiq.gitaly.serviceName`                          | Gitaly service name                            | `gitaly`                                                         |
| `gitlab.sidekiq.image.pullPolicy`                            | Sidekiq image pull policy                      |                                                          |
| `gitlab.sidekiq.image.repository`                            | Sidekiq image repository                       | `registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ee`     |
| `gitlab.sidekiq.image.tag`                                   | Sidekiq image tag                              | `latest`                                                         |
| `gitlab.sidekiq.psql.password.key`                           | key to psql password in psql secret            | `psql-password`                                                  |
| `gitlab.sidekiq.psql.password.secret`                        | psql password secret                           | `gitlab-postgres`                                                |
| `gitlab.sidekiq.psql.port`                                   | Set PostgreSQL server port. Takes precedence over `global.psql.port`
|                                                                  |
| `gitlab.sidekiq.replicas`                                    | Sidekiq replicas                               | `1`                                                              |
| `gitlab.sidekiq.resources.requests.cpu`                      | Sidekiq minimum needed cpu                     | `100m`                                                           |
| `gitlab.sidekiq.resources.requests.memory`                   | Sidekiq minimum needed memory                  | `600M`                                                           |
| `gitlab.sidekiq.securityContext.fsGroup`                     | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.sidekiq.securityContext.runAsUser`                   | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.sidekiq.timeout`                                     | Sidekiq job timeout                            | `5`                                                              |
| `gitlab.task-runner.annotations`                             | Annotations to add to the task runner          | {}                                                               |
| `gitlab.task-runner.backups.cron.enabled`                      | Backup CronJob enabled flag                  | false                                                            |
| `gitlab.task-runner.backups.cron.extraArgs`                    | String of args to pass to the backup utility |                                                                  |
| `gitlab.task-runner.backups.cron.persistence.accessMode`       | Backup cron persistence access mode          | `ReadWriteOnce`                                                  |
| `gitlab.task-runner.backups.cron.persistence.enabled`          | Backup cron enable persistence flag          | false                                                            |
| `gitlab.task-runner.backups.cron.persistence.matchExpressions` | Label-expression matches to bind             |                                                                  |
| `gitlab.task-runner.backups.cron.persistence.matchLabels`      | Label-value matches to bind                  |                                                                  |
| `gitlab.task-runner.backups.cron.persistence.size`             | Backup cron persistence volume size          | `10Gi`                                                           |
| `gitlab.task-runner.backups.cron.persistence.storageClass`     | storageClassName for provisioning            |                                                                  |
| `gitlab.task-runner.backups.cron.persistence.subPath`          | Backup cron persistence volume mount path    |                                                                  |
| `gitlab.task-runner.backups.cron.persistence.volumeName`       | Existing persistent volume name              |                                                                  |
| `gitlab.task-runner.backups.cron.resources.requests.cpu`       | Backup cron minimum needed cpu               | `50m`                                                            |
| `gitlab.task-runner.backups.cron.resources.requests.memory`    | Backup cron minimum needed memory            | `350M`                                                           |
| `gitlab.task-runner.backups.cron.schedule`                     | Cron style schedule string                   | `0 1 * * *`                                                      |
| `gitlab.task-runner.backups.objectStorage.backend`           | Object storage provider to use (`s3` or `gcs`) | `s3`                                                             |
| `gitlab.task-runner.backups.objectStorage.config.gcpProject` | GCP Project to use when backend is `gcs`       | ""                                                               |
| `gitlab.task-runner.backups.objectStorage.config.key`        | key containing credentials in secret           | ""                                                               |
| `gitlab.task-runner.backups.objectStorage.config.secret`     | Object storage credentials secret              | ""                                                               |
| `gitlab.task-runner.backups.objectStorage.config`            | Authentication information for object storage  | {}                                                               |
| `gitlab.task-runner.bootsnap.enabled`                        | Enable Bootsnap cache in Task runner           | true                                                             |
| `gitlab.task-runner.enabled`                                 | Task runner enabled flag                       | true                                                             |
| `gitlab.task-runner.image.pullPolicy`                        | Task runner image pull policy                  | `IfNotPresent`                                                   |
| `gitlab.task-runner.image.repository`                        | Task runner image repository                   | `registry.gitlab.com/gitlab-org/build/cng/gitlab-task-runner-ee` |
| `gitlab.task-runner.image.tag`                               | Task runner image tag                          | `latest`                                                         |
| `gitlab.task-runner.init.image.repository`                   | Task runner init image repository              |                                                                  |
| `gitlab.task-runner.init.image.tag`                          | Task runner init image tag                     |                                                                  |
| `gitlab.task-runner.init.resources.requests.cpu`             | Task runner init minimum needed cpu            | `50m`                                                            |
| `gitlab.task-runner.persistence.accessMode`                  | Task runner persistence access mode            | `ReadWriteOnce`                                                  |
| `gitlab.task-runner.persistence.enabled`                     | Task runner enable persistence flag            | false                                                            |
| `gitlab.task-runner.persistence.matchExpressions`            | Label-expression matches to bind               |                                                                  |
| `gitlab.task-runner.persistence.matchLabels`                 | Label-value matches to bind                    |                                                                  |
| `gitlab.task-runner.persistence.size`                        | Task runner persistence volume size            | `10Gi`                                                           |
| `gitlab.task-runner.persistence.storageClass`                | storageClassName for provisioning              |                                                                  |
| `gitlab.task-runner.persistence.subPath`                     | Task runner persistence volume mount path      |                                                                  |
| `gitlab.task-runner.persistence.volumeName`                  | Existing persistent volume name                |                                                                  |
| `gitlab.task-runner.resources.requests.cpu`                  | Task runner minimum needed cpu                 | `50m`                                                            |
| `gitlab.task-runner.resources.requests.memory`               | Task runner minimum needed memory              | `350M`                                                           |
| `gitlab.task-runner.psql.port`                               | Set PostgreSQL server port. Takes precedence over `global.psql.port`
|                                                                  |
| `gitlab.task-runner.securityContext.fsGroup`                 | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.task-runner.securityContext.runAsUser`               | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.webservice.enabled`                                     | webservice enabled flag                           | true                                                             |
| `gitlab.webservice.gitaly.authToken.key`                        | Key to Gitaly token in Gitaly secret           | `token`                                                          |
| `gitlab.webservice.gitaly.authToken.secret`                     | Gitaly secret name                             | `{.Release.Name}-gitaly-secret`                                  |
| `gitlab.webservice.gitaly.serviceName`                          | Gitaly service name                            | `gitaly`                                                         |
| `gitlab.webservice.image.pullPolicy`                            | webservice image pull policy                      |                                                          |
| `gitlab.webservice.image.repository`                            | webservice image repository                       | `registry.gitlab.com/gitlab-org/build/cng/gitlab-webservice-ee`     |
| `gitlab.webservice.image.tag`                                   | webservice image tag                              | `latest`                                                         |
| `gitlab.webservice.psql.password.key`                           | Key to psql password in psql secret            | `psql-password`                                                  |
| `gitlab.webservice.psql.password.secret`                        | psql secret name                               | `gitlab-postgres`                                                |
| `gitlab.webservice.psql.port`                                   | Set PostgreSQL server port. Takes precedence over `global.psql.port`
|                                                                  |
| `gitlab.webservice.registry.api.port`                           | Registry port                                  | `5000`                                                           |
| `gitlab.webservice.registry.api.protocol`                       | Registry protocol                              | `http`                                                           |
| `gitlab.webservice.registry.api.serviceName`                    | Registry service name                          | `registry`                                                       |
| `gitlab.webservice.registry.tokenIssuer`                        | Registry token issuer                          | `gitlab-issuer`                                                  |
| `gitlab.webservice.replicaCount`                                | webservice number of replicas                     | `1`                                                              |
| `gitlab.webservice.resources.requests.cpu`                      | webservice minimum cpu                            | `200m`                                                           |
| `gitlab.webservice.resources.requests.memory`                   | webservice minimum memory                         | `1.4G`                                                           |
| `gitlab.webservice.service.annotations`                         | Annotations to add to the `Service`            | {}                                                               |
| `gitlab.webservice.securityContext.fsGroup`                     | Group ID under which the pod should be started | `1000`                                                           |
| `gitlab.webservice.securityContext.runAsUser`                   | User ID under which the pod should be started  | `1000`                                                           |
| `gitlab.webservice.service.externalPort`                        | webservice exposed port                           | `8080`                                                           |
| `gitlab.webservice.service.internalPort`                        | webservice internal port                          | `8080`                                                           |
| `gitlab.webservice.service.type`                                | webservice service type                           | `ClusterIP`                                                      |
| `gitlab.webservice.service.workhorseExternalPort`               | Workhorse exposed port                         | `8181`                                                           |
| `gitlab.webservice.service.workhorseInternalPort`               | Workhorse internal port                        | `8181`                                                           |
| `gitlab.webservice.shell.authToken.key`                         | Key to shell token in shell secret             | `secret`                                                         |
| `gitlab.webservice.shell.authToken.secret`                      | Shell token secret                             | `{Release.Name}-gitlab-shell-secret`                             |
| `gitlab.webservice.workerProcesses`                             | webservice number of workers                      | `2`                                                              |
| `gitlab.webservice.workerTimeout`                               | webservice worker timeout                         | `60`                                                             |
| `gitlab.webservice.workhorse.extraArgs`                         | String of extra parameters for workhorse       | ""                                                               |
| `gitlab.webservice.workhorse.image`                             | Workhorse image repository                     | `registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ee`   |
| `gitlab.webservice.workhorse.sentryDSN`                         | DSN for Sentry instance for error reporting    | ""                                                               |
| `gitlab.webservice.workhorse.tag`                               | Workhorse image tag                            |                                                                  |

## External Charts

GitLab makes use of several other charts. These are [treated as parent-child relationships](https://helm.sh/docs/topics/charts/#chart-dependencies).
Ensure that any properties you wish to configure are provided as `chart-name.property`.

## Prometheus

Prefix Prometheus values with `prometheus`. For example, set the persistence
storage value using `prometheus.server.persistentVolume.size`.

Refer to the [Prometheus chart documentation](https://github.com/helm/charts/tree/master/stable/prometheus#configuration)
for the exhaustive list of configuration options.

## Bringing your own images

In certain scenarios (i.e. air-gapping), you may want to bring your own images rather than pulling them down from the Internet. This requires specifying your own Docker image registry/repository for each of the charts that make up the GitLab release.

Refer to the [custom images documentation](../advanced/custom-images/index.md) for more information.
