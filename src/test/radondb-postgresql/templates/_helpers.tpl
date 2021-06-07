{{/* vim: set filetype=mustache: */}}

{{/*
Fully qualified app name for PostgreSQL
*/}}
{{- define "radondb.postgresql" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified app name for Pgpool
*/}}
{{- define "radondb.pgpool" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-pgpool" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-pgpool" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-pgpool" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified app name for LDAP
*/}}
{{- define "radondb.ldap" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-ldap" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-ldap" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ldap" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "radondb.postgresqlImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.postgresqlImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Pgpool image name
*/}}
{{- define "radondb.pgpoolImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.pgpoolImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "radondb.volumePermissionsImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissionsImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "radondb.metricsImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metricsImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "radondb.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.postgresqlImage .Values.pgpoolImage .Values.volumePermissionsImage .Values.metricsImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the PostgreSQL username
*/}}
{{- define "radondb.postgresqlUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.username -}}
            {{- .Values.global.postgresql.username -}}
        {{- else -}}
            {{- .Values.postgresql.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.username -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL postgres user password
*/}}
{{- define "radondb.postgresqlPostgresPassword" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.postgresPassword -}}
            {{- .Values.global.postgresql.postgresPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if PostgreSQL postgres user password has been provided
*/}}
{{- define "radondb.postgresqlPasswordProvided" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.postgresPassword -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.postgresql.postgresPassword -}}
      {{- true -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL password
*/}}
{{- define "radondb.postgresqlPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.password }}
            {{- .Values.global.postgresql.password -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin username
*/}}
{{- define "radondb.pgpoolAdminUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.adminUsername -}}
            {{- .Values.global.pgpool.adminUsername -}}
        {{- else -}}
            {{- .Values.pgpool.adminUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.pgpool.adminUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.pgpool.adminUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin password
*/}}
{{- define "radondb.pgpoolAdminPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.adminPassword -}}
            {{- .Values.global.pgpool.adminPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL database to create
*/}}
{{- define "radondb.postgresqlDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- $postgresqlDatabase := default "postgres" .Values.postgresql.database -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.database -}}
            {{- default "postgres" .Values.global.postgresql.database -}}
        {{- else -}}
            {{- $postgresqlDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- $postgresqlDatabase -}}
    {{- end -}}
{{- else -}}
    {{- $postgresqlDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr username
*/}}
{{- define "radondb.postgresqlRepmgrUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrUsername -}}
            {{- .Values.global.postgresql.repmgrUsername -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr password
*/}}
{{- define "radondb.postgresqlRepmgrPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrPassword -}}
            {{- .Values.global.postgresql.repmgrPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database to use for repmgr
*/}}
{{- define "radondb.repmgrDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrDatabase -}}
            {{- .Values.global.postgresql.repmgrDatabase -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrDatabase -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for PostgreSQL
*/}}
{{- define "radondb.postgresqlCreateSecret" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.existingSecret -}}
        {{- else if (not .Values.postgresql.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.postgresql.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.postgresql.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL credentials secret.
*/}}
{{- define "radondb.postgresqlSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.existingSecret -}}
            {{- printf "%s" (tpl .Values.global.postgresql.existingSecret $) -}}
        {{- else if .Values.postgresql.existingSecret -}}
            {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
        {{- else -}}
            {{- printf "%s" (include "radondb.postgresql" .) -}}
        {{- end -}}
     {{- else if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.postgresql" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.postgresql" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Pgpool
*/}}
{{- define "radondb.pgpoolCreateSecret" -}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.existingSecret -}}
        {{- else if (not .Values.pgpool.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.pgpool.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.pgpool.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool credentials secret.
*/}}
{{- define "radondb.pgpoolSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.existingSecret -}}
            {{- printf "%s" .Values.global.pgpool.existingSecret -}}
        {{- else if .Values.pgpool.existingSecret -}}
            {{- printf "%s" .Values.pgpool.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "radondb.pgpool" .) -}}
        {{- end -}}
     {{- else if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.pgpool" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.pgpool" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL configuration configmap.
*/}}
{{- define "radondb.postgresqlConfigurationCM" -}}
{{- if .Values.postgresql.configurationCM -}}
{{- printf "%s" (tpl .Values.postgresql.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "radondb.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL extended configuration configmap.
*/}}
{{- define "radondb.postgresqlExtendedConfCM" -}}
{{- if .Values.postgresql.extendedConfCM -}}
{{- printf "%s" (tpl .Values.postgresql.extendedConfCM $) -}}
{{- else -}}
{{- printf "%s-extended-configuration" (include "radondb.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool configuration configmap.
*/}}
{{- define "radondb.pgpoolConfigurationCM" -}}
{{- if .Values.pgpool.configurationCM -}}
{{- printf "%s" (tpl .Values.pgpool.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "radondb.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL initdb scripts configmap.
*/}}
{{- define "radondb.postgresqlInitdbScriptsCM" -}}
{{- if .Values.postgresql.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.postgresql.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "radondb.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "radondb.postgresqlInitdbScriptsSecret" -}}
{{- if .Values.postgresql.initdbScriptsSecret -}}
{{- include "common.tplvalues.render" (dict "value" .Values.postgresql.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool initdb scripts configmap.
*/}}
{{- define "radondb.pgpoolInitdbScriptsCM" -}}
{{- if .Values.pgpool.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.pgpool.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "radondb.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the pgpool initialization scripts Secret name.
*/}}
{{- define "radondb.pgpoolInitdbScriptsSecret" -}}
{{- if .Values.pgpool.initdbScriptsSecret -}}
{{- include "common.tplvalues.render" (dict "value" .Values.pgpool.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP bind password
*/}}
{{- define "radondb.ldapPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.bindpw }}
            {{- .Values.global.ldap.bindpw -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP credentials secret.
*/}}
{{- define "radondb.ldapSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.existingSecret }}
            {{- printf "%s" .Values.global.ldap.existingSecret -}}
        {{- else if .Values.ldap.existingSecret -}}
            {{- printf "%s" .Values.ldap.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "radondb.ldap" .) -}}
        {{- end -}}
     {{- else if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.ldap" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "radondb.ldap" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkPolicy
*/}}
{{- define "radondb.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"extensions/v1beta1"
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"networking.k8s.io/v1"
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "radondb.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.postgresqlImage -}}
{{- include "common.warnings.rollingTag" .Values.pgpoolImage -}}
{{- include "common.warnings.rollingTag" .Values.metricsImage -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "radondb.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "radondb.validateValues.nodesHostnames" .) -}}
{{- $messages := append $messages (include "radondb.validateValues.ldap" .) -}}
{{- $messages := append $messages (include "radondb.validateValues.ldapPgHba" .) -}}
{{- $messages := append $messages (include "radondb.validateValues.upgradeRepmgrExtension" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL nodes hostnames cannot be longer than 128 characters */}}
{{- define "radondb.validateValues.nodesHostnames" -}}
{{- $postgresqlFullname := include "radondb.postgresql" . }}
{{- $postgresqlHeadlessServiceName := printf "%s-headless" (include "radondb.postgresql" .) }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain:= .Values.clusterDomain }}
{{- $nodeHostname := printf "%s-00.%s.%s.svc.%s:1234" $postgresqlFullname $postgresqlHeadlessServiceName $releaseNamespace $clusterDomain }}
{{- if gt (len $nodeHostname) 128 -}}
radondb: Nodes hostnames
    PostgreSQL nodes hostnames ({{ $nodeHostname }}) exceeds the characters limit for Pgpool: 128.
    Consider using a shorter release name or namespace.
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - must provide mandatory LDAP parameters when LDAP is enabled */}}
{{- define "radondb.validateValues.ldap" -}}
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.base) (empty .Values.ldap.binddn) (empty .Values.ldap.bindpw)) -}}
radondb: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.base", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} qingcloud/radondb \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.base="dc=example\,dc=org" \
      --set ldap.binddn="cn=admin\,dc=example\,dc=org" \
      --set ldap.bindpw="admin"
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL HBA configuration must trust every user when LDAP is enabled */}}
{{- define "radondb.validateValues.ldapPgHba" -}}
{{- if and .Values.ldap.enabled (not .Values.postgresql.pgHbaTrustAll) }}
radondb: LDAP & pg_hba.conf
    PostgreSQL HBA configuration must trust every user when LDAP is enabled.
    Please configure HBA to trust every user (--set postgresql.pgHbaTrustAll=true)
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - There must be an unique replica when upgrading repmgr extension */}}
{{- define "radondb.validateValues.upgradeRepmgrExtension" -}}
{{- $postgresqlReplicaCount := int .Values.postgresql.replicaCount }}
{{- if and .Values.postgresql.upgradeRepmgrExtension (gt $postgresqlReplicaCount 1) }}
radondb: Upgrade repmgr extension
    There must be only one replica when upgrading repmgr extension:

    $ helm upgrade {{ .Release.Name }} qingcloud/radondb \
      --set postgresql.replicaCount=1 \
      --set postgresql.upgradeRepmgrExtension=true
{{- end -}}
{{- end -}}

{{/* Set PGPASSWORD as environment variable depends on configuration */}}
{{- define "radondb.pgpassword" -}}
{{- if .Values.postgresql.usePasswordFile -}}
PGPASSWORD=$(< $POSTGRES_PASSWORD_FILE)
{{- else -}}
PGPASSWORD=$POSTGRES_PASSWORD
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool secret containing custom users to be added to
pool_passwd file.
*/}}
{{- define "radondb.pgpoolCustomUsersSecretName" -}}
{{- if .Values.pgpool.customUsersSecret -}}
{{- printf "%s" (tpl .Values.pgpool.customUsersSecret $) -}}
{{- else -}}
{{- printf "%s-custom-users" (include "radondb.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "radondb.pgpool.tlsCert" -}}
{{- required "Certificate filename is required when TLS in enabled" .Values.pgpool.tls.certFilename | printf "/opt/qingcloud/pgpool/certs/%s" -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "radondb.pgpool.tlsCertKey" -}}
{{- required "Certificate Key filename is required when TLS in enabled" .Values.pgpool.tls.certKeyFilename | printf "/opt/qingcloud/pgpool/certs/%s" -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "radondb.pgpool.tlsCACert" -}}
{{- printf "/opt/qingcloud/pgpool/certs/%s" .Values.pgpool.tls.certCAFilename -}}
{{- end -}}
