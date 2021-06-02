## What is RadonDB PostgreSQL

[RadonDB PostgreSQL](https://github.com/radondb/radondb-postgresql-kubernetes) is an open-source, cloud-native, highly availability cluster solutions based on PostgreSQL. 

RadonDB PostgreSQL supports [Kubernetes](https://kubernetes.io) or [KubeShpere](https://kubesphere.com.cn) platforms.

## Architecture

- Supporting automatic failover through [repmgr](https://repmgr.org/docs/current/)
- Load-balancing I/O traffic through [Pgpool-II](https://www.pgpool.net/)
- Keeping data consistency through `PostgreSQL Streaming Replication`
## Features 

- High Availability PostgreSQL database
    - Leader-follower switching in second-level
    - Asynchronous or Synchronous streaming replication
    - Automatic failover
- Cluster Management
- Failover and Load-Balancing
- Parameter Tuning

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
## For Helm v2
$ helm install . --name my-release

## For Helm v3
$ helm install --name my-release .
```

The command deploys postgresql cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

To delete the pvc:

```
kubectl delete pvc data-my-release-radondb-postgresql-0
kubectl delete pvc data-my-release-radondb-postgresql-1
kubectl delete pvc data-my-release-radondb-postgresql-2
```

The commands remove all the Kubernetes components associated with the chart and deletes the release completely.

## Configuration

| Parameter                                       | Description                                                  | Default                                                      |
| ----------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **Global**                                      |                                                              |                                                              |
| `global.imageRegistry`                          | Global Docker image registry                                 | `nil`                                                        |
| `global.imagePullSecrets`                       | Global Docker registry secret names as an array              | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                           | Global storage class for dynamic provisioning                | `nil`                                                        |
| `global.postgresql.existingSecret`              | Name of existing secret to use for PostgreSQL passwords (overrides `postgresql.existingSecret`) | `nil`                                                        |
| `global.postgresql.username`                    | PostgreSQL username (overrides `postgresql.username`)        | `nil`                                                        |
| `global.postgresql.password`                    | PostgreSQL password (overrides `postgresql.password`)        | `nil`                                                        |
| `global.postgresql.database`                    | PostgreSQL database (overrides `postgresql.database`)        | `nil`                                                        |
| `global.postgresql.repmgrUsername`              | PostgreSQL repmgr username (overrides `postgresql.repmgrUsername`) | `nil`                                                        |
| `global.postgresql.repmgrPassword`              | PostgreSQL repmgr password (overrides `postgresql.repmgrpassword`) | `nil`                                                        |
| `global.postgresql.repmgrDatabase`              | PostgreSQL repmgr database (overrides `postgresql.repmgrDatabase`) | `nil`                                                        |
| `global.ldap.existingSecret`                    | Name of existing secret to use for LDAP passwords (overrides `ldap.existingSecret`) | `nil`                                                        |
| `global.ldap.bindpw`                            | LDAP bind password (overrides `ldap.bindpw`)                 | `nil`                                                        |
| `global.pgpool.adminUsername`                   | Pgpool Admin username (overrides `pgpool.adminUsername`)     | `nil`                                                        |
| `global.pgpool.adminPassword`                   | Pgpool Admin password (overrides `pgpool.adminPassword`)     | `nil`                                                        |
| **General**                                     |                                                              |                                                              |
| `commonLabels`                                  | Labels to add to all deployed objects                        | `nil`                                                        |
| `commonAnnotations`                             | Annotations to add to all deployed objects                   | `[]`                                                         |
| `nameOverride`                                  | String to partially override postgres-ha.fullname template with a string | `nil`                                                        |
| `fullnameOverride`                              | String to fully override postgres-ha.fullname template with a string | `nil`                                                        |
| `clusterDomain`                                 | Default Kubernetes cluster domain                            | `cluster.local`                                              |
| `extraDeploy`                                   | Array of extra objects to deploy with the release (evaluated as a template). | `nil`                                                        |
| `serviceAccount.enabled`                        | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set) | `false`                                                      |
| `serviceAccount.name`                           | Name of existing service account                             | `nil`                                                        |
| **PostgreSQL with Repmgr**                      |                                                              |                                                              |
| `postgresqlImage.registry`                      | Registry for PostgreSQL with Repmgr image                    | `docker.io`                                                  |
| `postgresqlImage.tag`                           | Tag for PostgreSQL with Repmgr image                         | `{TAG_NAME}`                                                 |
| `postgresqlImage.pullPolicy`                    | PostgreSQL with Repmgr image pull policy                     | `IfNotPresent`                                               |
| `postgresqlImage.pullSecrets`                   | Specify docker-registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods)      |
| `postgresqlImage.debug`                         | Specify if debug logs should be enabled                      | `false`                                                      |
| `postgresql.hostAliases`                        | Add deployment host aliases                                  | `[]`                                                         |
| `postgresql.labels`                             | Map of labels to add to the statefulset. Evaluated as a template | `{}`                                                         |
| `postgresql.podLabels`                          | Map of labels to add to the pods. Evaluated as a template    | `{}`                                                         |
| `postgresql.replicaCount`                       | The number of replicas to deploy                             | `2`                                                          |
| `postgresql.updateStrategyType`                 | Statefulset update strategy policy                           | `RollingUpdate`                                              |
| `postgresql.podAnnotations`                     | Additional pod annotations                                   | `{}`                                                         |
| `postgresql.priorityClassName`                  | Pod priority class                                           | ``                                                           |
| `postgresql.podAffinityPreset`                  | PostgreSQL pod affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `postgresql.podAntiAffinityPreset`              | PostgreSQL pod anti-affinity preset. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard` | `soft`                                                       |
| `postgresql.nodeAffinityPreset.type`            | PostgreSQL node affinity preset type. Ignored if `postgresql.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `postgresql.nodeAffinityPreset.key`             | PostgreSQL node label key to match Ignored if `postgresql.affinity` is set. | `""`                                                         |
| `postgresql.nodeAffinityPreset.values`          | PostgreSQL node label values to match. Ignored if `postgresql.affinity` is set. | `[]`                                                         |
| `postgresql.affinity`                           | Affinity for PostgreSQL pods assignment                      | `{}` (evaluated as a template)                               |
| `postgresql.nodeSelector`                       | Node labels for PostgreSQL pods assignment                   | `{}` (evaluated as a template)                               |
| `postgresql.tolerations`                        | Tolerations for PostgreSQL pods assignment                   | `[]` (evaluated as a template)                               |
| `postgresql.securityContext.*`                  | Other pod security context to be included as-is in the pod spec | `{}`                                                         |
| `postgresql.securityContext.enabled`            | Enable security context for PostgreSQL with Repmgr           | `true`                                                       |
| `postgresql.securityContext.fsGroup`            | Group ID for the PostgreSQL with Repmgr filesystem           | `1001`                                                       |
| `postgresql.containerSecurityContext.*`         | Other container security context to be included as-is in the container spec | `{}`                                                         |
| `postgresql.containerSecurityContext.enabled`   | Enable container security context                            | `true`                                                       |
| `postgresql.containerSecurityContext.runAsUser` | User ID for the PostgreSQL with Repmgr container             | `1001`                                                       |
| `postgresql.resources`                          | The [resources] to allocate for container                    | `{}`                                                         |
| `postgresql.livenessProbe`                      | Liveness probe configuration for PostgreSQL with Repmgr      | `Check values.yaml file`                                     |
| `postgresql.readinessProbe`                     | Readiness probe configuration for PostgreSQL with Repmgr     | `Check values.yaml file`                                     |
| `postgresql.startupProbe`                       | Startup probe configuration for PostgreSQL with Repmgr       | `Check values.yaml file`                                     |
| `postgresql.customLivenessProbe`                | Override default liveness probe                              | `nil`                                                        |
| `postgresql.customReadinessProbe`               | Override default readiness probe                             | `nil`                                                        |
| `postgresql.customStartupProbe`                 | Override default startup probe                               | `nil`                                                        |
| `postgresql.extraVolumeMounts`                  | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `nil`                                                        |
| `postgresql.sidecars`                           | Attach additional containers to the pod (evaluated as a template) | `nil`                                                        |
| `postgresql.initContainers`                     | Add additional init containers to the pod (evaluated as a template) | `nil`                                                        |
| `postgresql.extraEnvVars`                       | Array containing extra env vars                              | `nil`                                                        |
| `postgresql.extraEnvVarsCM`                     | ConfigMap containing extra env vars                          | `nil`                                                        |
| `postgresql.extraEnvVarsSecret`                 | Secret containing extra env vars (in case of sensitive data) | `nil`                                                        |
| `postgresql.command`                            | Override default container command (useful when using custom images) | `nil`                                                        |
| `postgresql.args`                               | Override default container args (useful when using custom images) | `nil`                                                        |
| `postgresql.lifecycleHooks`                     | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template | ``                                                           |
| `postgresql.pdb.create`                         | If true, create a pod disruption budget for PostgreSQL with Repmgr pods | `false`                                                      |
| `postgresql.pdb.minAvailable`                   | Minimum number / percentage of pods that should remain scheduled | `1`                                                          |
| `postgresql.pdb.maxUnavailable`                 | Maximum number / percentage of pods that may be made unavailable | `nil`                                                        |
| `postgresql.username`                           | PostgreSQL username                                          | `postgres`                                                   |
| `postgresql.password`                           | PostgreSQL password                                          | `nil`                                                        |
| `postgresql.existingSecret`                     | Name of existing secret to use for PostgreSQL passwords      | `nil`                                                        |
| `postgresql.postgresPassword`                   | PostgreSQL password for the `postgres` user when `username` is not `postgres` | `nil`                                                        |
| `postgresql.database`                           | PostgreSQL database                                          | `postgres`                                                   |
| `postgresql.usePasswordFile`                    | Have the secrets mounted as a file instead of env vars       | `false`                                                      |
| `postgresql.repmgrUsePassfile`                  | Configure repmgrl to use `passfile` instead of `password` vars | `false`                                                      |
| `postgresql.repmgrPassfilePath`                 | Custom path where `passfile` will be stored                  | `nil`                                                        |
| `postgresql.upgradeRepmgrExtension`             | Upgrade repmgr extension in the database                     | `false`                                                      |
| `postgresql.pgHbaTrustAll`                      | Configures PostgreSQL HBA to trust every user                | `false`                                                      |
| `postgresql.syncReplication`                    | Make the replication synchronous. This will wait until the data is synchronized in all the replicas before other query can be run. This ensures the data availability at the expenses of speed. | `false`                                                      |
| `postgresql.sharedPreloadLibraries`             | Shared preload libraries (comma-separated list)              | `pgaudit, repmgr`                                            |
| `postgresql.maxConnections`                     | Maximum total connections                                    | `nil`                                                        |
| `postgresql.postgresConnectionLimit`            | Maximum total connections for the postgres user              | `nil`                                                        |
| `postgresql.dbUserConnectionLimit`              | Maximum total connections for the non-admin user             | `nil`                                                        |
| `postgresql.tcpKeepalivesInterval`              | TCP keepalives interval                                      | `nil`                                                        |
| `postgresql.tcpKeepalivesIdle`                  | TCP keepalives idle                                          | `nil`                                                        |
| `postgresql.tcpKeepalivesCount`                 | TCP keepalives count                                         | `nil`                                                        |
| `postgresql.statementTimeout`                   | Statement timeout                                            | `nil`                                                        |
| `postgresql.pghbaRemoveFilters`                 | Comma-separated list of patterns to remove from the pg_hba.conf file | `nil`                                                        |
| `postgresql.audit.logHostname`                  | Add client hostnames to the log file                         | `true`                                                       |
| `postgresql.audit.logConnections`               | Add client log-in operations to the log file                 | `false`                                                      |
| `postgresql.audit.logDisconnections`            | Add client log-outs operations to the log file               | `false`                                                      |
| `postgresql.audit.pgAuditLog`                   | Add operations to log using the pgAudit extension            | `nil`                                                        |
| `postgresql.audit.clientMinMessages`            | Message log level to share with the user                     | `nil`                                                        |
| `postgresql.audit.logLinePrefix`                | Template string for the log line prefix                      | `nil`                                                        |
| `postgresql.audit.logTimezone`                  | Timezone for the log timestamps                              | `nil`                                                        |
| `postgresql.repmgrUsername`                     | PostgreSQL repmgr username                                   | `repmgr`                                                     |
| `postgresql.repmgrPassword`                     | PostgreSQL repmgr password                                   | `nil`                                                        |
| `postgresql.repmgrDatabase`                     | PostgreSQL repmgr database                                   | `repmgr`                                                     |
| `postgresql.repmgrLogLevel`                     | Repmgr log level (DEBUG, INFO, NOTICE, WARNING, ERROR, ALERT, CRIT or EMERG) | `NOTICE`                                                     |
| `postgresql.repmgrConnectTimeout`               | Repmgr backend connection timeout (in seconds)               | `5`                                                          |
| `postgresql.repmgrReconnectAttempts`            | Repmgr backend reconnection attempts                         | `3`                                                          |
| `postgresql.repmgrReconnectInterval`            | Repmgr backend reconnection interval (in seconds)            | `5`                                                          |
| `postgresql.repmgrConfiguration`                | Repmgr Configuration                                         | `nil`                                                        |
| `postgresql.configuration`                      | PostgreSQL Configuration                                     | `nil`                                                        |
| `postgresql.pgHbaConfiguration`                 | Content of pg\_hba.conf                                      | `nil (do not create pg_hba.conf)`                            |
| `postgresql.configurationCM`                    | ConfigMap with the PostgreSQL configuration files (Note: Overrides `postgresql.repmgrConfiguration`, `postgresql.configuration` and `postgresql.pgHbaConfiguration`) | `nil` (The value is evaluated as a template)                 |
| `postgresql.extendedConf`                       | Extended PostgreSQL Configuration (appended to main or default configuration). Implies `volumePermissions.enabled`. | `nil`                                                        |
| `postgresql.extendedConfCM`                     | ConfigMap with the extended PostgreSQL configuration files (Note: Overrides `postgresql.extendedConf`)  Implies `volumePermissions.enabled`. | `nil` (The value is evaluated as a template)                 |
| `postgresql.initdbScripts`                      | Dictionary of initdb scripts                                 | `nil`                                                        |
| `postgresql.initdbScriptsCM`                    | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template. | `nil`                                                        |
| `postgresql.initdbScriptsSecret`                | Secret with initdb scripts that contain sensitive information (Note: can be used with initdbScriptsCM or initdbScripts). The value is evaluated as a template. | `nil`                                                        |
| **Pgpool**                                      |                                                              |                                                              |
| `pgpoolImage.registry`                          | Registry for Pgpool                                          | `docker.io`                                                  |
| `pgpoolImage.tag`                               | Tag for Pgpool                                               | `{TAG_NAME}`                                                 |
| `pgpoolImage.pullPolicy`                        | Pgpool image pull policy                                     | `IfNotPresent`                                               |
| `pgpoolImage.pullSecrets`                       | Specify docker-registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods)      |
| `pgpoolImage.debug`                             | Specify if debug logs should be enabled                      | `false`                                                      |
| `pgpool.customUsers.usernames`                  | Comma or semicolon separated list of postgres usernames to be added to pgpool_passwd | `nil`                                                        |
| `pgpool.customUsers.passwords`                  | Comma or semicolon separated list of the associated passwords for the users to be added to pgpool_passwd | `nil`                                                        |
| `pgpool.customUsersSecret`                      | Name of a secret containing the usernames and passwords of accounts that will be added to pgpool_passwd | `nil`                                                        |
| `pgpool.srCheckDatabase`                        | Name of the database to perform streaming replication checks | `postgres`                                                   |
| `pgpool.hostAliases`                            | Add deployment host aliases                                  | `[]`                                                         |
| `pgpool.labels`                                 | Map of labels to add to the deployment. Evaluated as a template | `{}`                                                         |
| `pgpool.podLabels`                              | Map of labels to add to the pods. Evaluated as a template    | `{}`                                                         |
| `pgpool.replicaCount`                           | The number of replicas to deploy                             | `1`                                                          |
| `pgpool.customLivenessProbe`                    | Override default liveness probe                              | `nil`                                                        |
| `pgpool.customReadinessProbe`                   | Override default readiness probe                             | `nil`                                                        |
| `pgpool.customStartupProbe`                     | Override default startup probe                               | `nil`                                                        |
| `pgpool.extraVolumeMounts`                      | Array of extra volume mounts to be added to the container (evaluated as template). Normally used with `extraVolumes`. | `nil`                                                        |
| `pgpool.sidecars`                               | Attach additional containers to the pod (evaluated as a template) | `nil`                                                        |
| `pgpool.initContainers`                         | Add additional init containers to the pod (evaluated as a template) | `nil`                                                        |
| `pgpool.extraEnvVars`                           | Array containing extra env vars                              | `nil`                                                        |
| `pgpool.extraEnvVarsCM`                         | ConfigMap containing extra env vars                          | `nil`                                                        |
| `pgpool.extraEnvVarsSecret`                     | Secret containing extra env vars (in case of sensitive data) | `nil`                                                        |
| `pgpool.command`                                | Override default container command (useful when using custom images) | `nil`                                                        |
| `pgpool.args`                                   | Override default container args (useful when using custom images) | `nil`                                                        |
| `pgpool.lifecycleHooks`                         | LifecycleHook to set additional configuration at startup, e.g. LDAP settings via REST API. Evaluated as a template | ``                                                           |
| `pgpool.podAnnotations`                         | Additional pod annotations                                   | `{}`                                                         |
| `pgpool.initdbScripts`                          | Dictionary of initdb scripts                                 | `nil`                                                        |
| `pgpool.initdbScriptsCM`                        | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template. | `nil`                                                        |
| `pgpool.initdbScriptsSecret`                    | Secret with initdb scripts that contain sensitive information (Note: can be used with initdbScriptsCM or initdbScripts). The value is evaluated as a template. | `nil`                                                        |
| `pgpool.priorityClassName`                      | Pod priority class                                           | ``                                                           |
| `pgpool.podAffinityPreset`                      | Pgpool pod affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `pgpool.podAntiAffinityPreset`                  | Pgpool pod anti-affinity preset. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard` | `soft`                                                       |
| `pgpool.nodeAffinityPreset.type`                | Pgpool node affinity preset type. Ignored if `pgpool.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                         |
| `pgpool.nodeAffinityPreset.key`                 | Pgpool node label key to match Ignored if `pgpool.affinity` is set. | `""`                                                         |
| `pgpool.nodeAffinityPreset.values`              | Pgpool node label values to match. Ignored if `pgpool.affinity` is set. | `[]`                                                         |
| `pgpool.affinity`                               | Affinity for Pgpool pods assignment                          | `{}` (evaluated as a template)                               |
| `pgpool.nodeSelector`                           | Node labels for Pgpool pods assignment                       | `{}` (evaluated as a template)                               |
| `pgpool.tolerations`                            | Tolerations for Pgpool pods assignment                       | `[]` (evaluated as a template)                               |
| `pgpool.securityContext.*`                      | Other pod security context to be included as-is in the pod spec | `{}`                                                         |
| `pgpool.securityContext.enabled`                | Enable security context for Pgpool                           | `true`                                                       |
| `pgpool.securityContext.fsGroup`                | Group ID for the Pgpool filesystem                           | `1001`                                                       |
| `pgpool.containerSecurityContext.*`             | Other container security context to be included as-is in the container spec | `{}`                                                         |
| `pgpool.containerSecurityContext.enabled`       | Enable container security context                            | `true`                                                       |
| `pgpool.containerSecurityContext.runAsUser`     | User ID for the Pgpool container                             | `1001`                                                       |
| `pgpool.resources`                              | The [resources] to allocate for container                    | `{}`                                                         |
| `pgpool.livenessProbe`                          | Liveness probe configuration for Pgpool                      | `Check values.yaml file`                                     |
| `pgpool.readinessProbe`                         | Readiness probe configuration for Pgpool                     | `Check values.yaml file`                                     |
| `pgpool.startupProbe`                           | Startup probe configuration for Pgpool                       | `Check values.yaml file`                                     |
| `pgpool.pdb.create`                             | If true, create a pod disruption budget for Pgpool pods.     | `false`                                                      |
| `pgpool.pdb.minAvailable`                       | Minimum number / percentage of pods that should remain scheduled | `1`                                                          |
| `pgpool.pdb.maxUnavailable`                     | Maximum number / percentage of pods that may be made unavailable | `nil`                                                        |
| `pgpool.updateStrategy`                         | Strategy used to replace old Pods by new ones                | `{}`                                                         |
| `pgpool.minReadySeconds`                        | How many seconds a pod needs to be ready before killing the next, during update | `nil`                                                        |
| `pgpool.adminUsername`                          | Pgpool Admin username                                        | `admin`                                                      |
| `pgpool.adminPassword`                          | Pgpool Admin password                                        | `nil`                                                        |
| `pgpool.logConnections`                         | Log all client connections                                   | `false`                                                      |
| `pgpool.logHostname`                            | Log the client hostname instead of IP address                | `true`                                                       |
| `pgpool.logPerNodeStatement`                    | Log every SQL statement for each DB node separately          | `false`                                                      |
| `pgpool.logLinePrefix`                          | Format of the log entry lines                                | `nil`                                                        |
| `pgpool.clientMinMessages`                      | Log level for clients                                        | `error`                                                      |
| `pgpool.numInitChildren`                        | The number of preforked Pgpool-II server processes.          | `32`                                                         |
| `pgpool.maxPool`                                | The maximum number of cached connections in each child process | `15`                                                         |
| `pgpool.childMaxConnections`                    | The maximum number of client connections in each child process | `nil`                                                        |
| `pgpool.childLifeTime`                          | The time in seconds to terminate a Pgpool-II child process if it remains idle | `nil`                                                        |
| `pgpool.clientIdleLimit`                        | The time in seconds to disconnect a client if it remains idle since the last query | `nil`                                                        |
| `pgpool.connectionLifeTime`                     | The time in seconds to terminate the cached connections to the PostgreSQL backend | `nil`                                                        |
| `pgpool.useLoadBalancing`                       | If true, use Pgpool Load-Balancing                           | `true`                                                       |
| `pgpool.configuration`                          | Content of pgpool.conf                                       | `nil`                                                        |
| `pgpool.configurationCM`                        | ConfigMap with the Pgpool configuration file (Note: Overrides `pgpol.configuration`). The file used must be named `pgpool.conf`. | `nil` (The value is evaluated as a template)                 |
| `pgpool.tls.enabled`                            | Enable TLS traffic support for end-client connections        | `false`                                                      |
| `pgpool.tls.preferServerCiphers`                | Whether to use the server's TLS cipher preferences rather than the client's | `true`                                                       |
| `pgpool.tls.certificatesSecret`                 | Name of an existing secret that contains the certificates    | `nil`                                                        |
| `pgpool.tls.certFilename`                       | Certificate filename                                         | `""`                                                         |
| `pgpool.tls.certKeyFilename`                    | Certificate key filename                                     | `""`                                                         |
| `pgpool.tls.certCAFilename`                     | CA Certificate filename. If provided, PgPool will authenticate TLS/SSL clients by requesting them a certificate. | `nil`                                                        |
| **LDAP**                                        |                                                              |                                                              |
| `ldap.enabled`                                  | Enable LDAP support                                          | `false`                                                      |
| `ldap.existingSecret`                           | Name of existing secret to use for LDAP passwords            | `nil`                                                        |
| `ldap.uri`                                      | LDAP URL beginning in the form `ldap[s]://<hostname>:<port>` | `nil`                                                        |
| `ldap.base`                                     | LDAP base DN                                                 | `nil`                                                        |
| `ldap.binddn`                                   | LDAP bind DN                                                 | `nil`                                                        |
| `ldap.bindpw`                                   | LDAP bind password                                           | `nil`                                                        |
| `ldap.bslookup`                                 | LDAP base lookup                                             | `nil`                                                        |
| `ldap.scope`                                    | LDAP search scope                                            | `nil`                                                        |
| `ldap.tlsReqcert`                               | LDAP TLS check on server certificates                        | `nil`                                                        |
| `ldap.nssInitgroupsIgnoreusers`                 | LDAP ignored users                                           | `root,nslcd`                                                 |
| **Prometheus metrics**                          |                                                              |                                                              |
| `metricsImage.registry`                         | Registry for PostgreSQL Prometheus exporter                  | `docker.io`                                                  |
| `metricsImage.tag`                              | Tag for PostgreSQL Prometheus exporter                       | `{TAG_NAME}`                                                 |
| `metricsImage.pullPolicy`                       | PostgreSQL Prometheus exporter image pull policy             | `IfNotPresent`                                               |
| `metricsImage.pullSecrets`                      | Specify docker-registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods)      |
| `metricsImage.debug`                            | Specify if debug logs should be enabled                      | `false`                                                      |
| `metrics.securityContext.*`                     | Other container security context to be included as-is in the container spec | `{}`                                                         |
| `metrics.securityContext.enabled`               | Enable security context for PostgreSQL Prometheus exporter   | `true`                                                       |
| `metrics.securityContext.runAsUser`             | User ID for the PostgreSQL Prometheus exporter container     | `1001`                                                       |
| `metrics.resources`                             | The [resources] to allocate for container                    | `{}`                                                         |
| `metrics.livenessProbe`                         | Liveness probe configuration for PostgreSQL Prometheus exporter | `Check values.yaml file`                                     |
| `metrics.readinessProbe`                        | Readiness probe configuration for PostgreSQL Prometheus exporter | `Check values.yaml file`                                     |
| `metrics.startupProbe`                          | Startup probe configuration for PostgreSQL Prometheus exporter | `Check values.yaml file`                                     |
| `metrics.annotations`                           | Annotations for PostgreSQL Prometheus exporter service       | `{prometheus.io/scrape: "true", prometheus.io/port: "9187"}` |
| `metrics.customMetrics`                         | Additional custom metrics                                                                                                                                                                       | `nil`
| `metrics.extraEnvVars`                         | Extra environment variables to add to exporter	                                                                                                                                                                       | `{} (evaluated as a template)`
| `metrics.serviceMonitor.enabled`                | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                                                                          | `false`                                                      |
| `metrics.serviceMonitor.namespace`              | Optional namespace which Prometheus is running in                                                                                                                                               | `nil`                                                        |
| `metrics.serviceMonitor.interval`               | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                                                                          | `nil`                                                        |
| `metrics.serviceMonitor.selector`               | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                                                      | `{prometheus: "kube-prometheus"}`                            |
| `metrics.serviceMonitor.relabelings`            | ServiceMonitor relabelings. Value is evaluated as a template                                                                                                                                    | `[]`                                                         |
| `metrics.serviceMonitor.metricRelabelings`      | ServiceMonitor metricRelabelings. Value is evaluated as a template                                                                                                                              | `[]`                                                         |
| **Init Container to adapt volume permissions**  |                                                                                                                                                                                                 |                                                              |
| `volumePermissionsImage.registry`               | Init container volume-permissions image registry                                                                                                                                                | `docker.io`                                                  |                                                                                                                                            | `latest`                                                     |
| `volumePermissionsImage.pullPolicy`             | Init container volume-permissions image pull policy                                                                                                                                             | `Always`                                                     |
| `volumePermissionsImage.pullSecrets`            | Specify docker-registry secret names as an array                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods)      |
| `volumePermissions.enabled`                     | Enable init container to adapt volume permissions                                                                                                                                               | `false`                                                      |
| `volumePermissions.securityContext.*`           | Other container security context to be included as-is in the container spec                                                                                                                     | `{}`                                                         |
| `volumePermissions.securityContext.enabled`     | Init container volume-permissions security context                                                                                                                                              | `false`                                                      |
| `volumePermissions.securityContext.runAsUser`   | Init container volume-permissions User ID                                                                                                                                                       | `0`                                                          |
| **Persistence**                                 |                                                                                                                                                                                                 |                                                              |
| `persistence.enabled`                           | Enable data persistence                                                                                                                                                                         | `true`                                                       |
| `persistence.existingClaim`                     | Use a existing PVC which must be created manually before bound. PVC will be shared between all replicas, which is useful for special cases only.                                                | `nil`                                                        |
| `persistence.storageClass`                      | Specify the `storageClass` used to provision the volume                                                                                                                                         | `nil`                                                        |
| `persistence.mountPath`                         | Path to mount data volume at                                                                                                                                                                    | `nil`                                                        |
| `persistence.accessModes`                       | List of access modes of data volume                                                                                                                                                             | `ReadWriteOnce`                                              |
| `persistence.size`                              | Size of data volume                                                                                                                                                                             | `8Gi`                                                        |
| `persistence.annotations`                       | Persistent Volume Claim annotations                                                                                                                                                             | `{}`                                                         |
| `persistence.selector`                          | Selector to match an existing Persistent Volume (this value is evaluated as a template)                                                                                                         | `{}`                                                         |
| **Expose**                                      |                                                                                                                                                                                                 |                                                              |
| `service.type`                                  | Kubernetes service type (`ClusterIP`, `NodePort` or `LoadBalancer`)                                                                                                                             | `ClusterIP`                                                  |
| `service.port`                                  | PostgreSQL port                                                                                                                                                                                 | `5432`                                                       |
| `service.nodePort`                              | Kubernetes service nodePort                                                                                                                                                                     | `nil`                                                        |
| `service.annotations`                           | Annotations for PostgreSQL service                                                                                                                                                              | `{}`                                                         |
| `service.serviceLabels`                         | Labels for PostgreSQL service                                                                                                                                                                   | `{}`                                                         |
| `service.loadBalancerIP`                        | loadBalancerIP if service type is `LoadBalancer`                                                                                                                                                | `nil`                                                        |
| `service.loadBalancerSourceRanges`              | Address that are allowed when service is LoadBalancer                                                                                                                                           | `[]`                                                         |
| `service.clusterIP`                             | Static clusterIP or None for headless services                                                                                                                                                  | `nil`                                                        |
| `service.externalTrafficPolicy`                 | Enable client source IP preservation                                                                                                                                                            | `Cluster`                                                    |
| `service.sessionAffinity `                      | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                            | `None`                                                       |
| `networkPolicy.enabled`                         | Enable NetworkPolicy                                                                                                                                                                            | `false`                                                      |
| `networkPolicy.allowExternal`                   | Don't require client label for connections                                                                                                                                                      | `true`                                                       |        |

## Custom PostgreSQL configuration

You can add or modify the postgresql configuration on the `values.yaml`
```yaml
    extendedConf: |-
    deadlock_timeout = 1s
    max_locks_per_transaction = 64
```