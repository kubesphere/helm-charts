{{/*
Return database configuration, if enabled.
*/}}
{{- define "registry.database.config" -}}
{{- if .Values.database.enabled }}
database:
  enabled: true
  host: {{ default (include "gitlab.psql.host" .) .Values.database.host | quote }}
  port: {{ default (include "gitlab.psql.port" .) .Values.database.port }}
  user: {{ .Values.database.user }}
  password: "DB_PASSWORD_FILE"
  dbname: {{ .Values.database.name }}
  sslmode: {{ .Values.database.sslmode }}
  {{- if .Values.database.ssl }}
  sslcert: /etc/docker/registry/ssl/client-certificate.pem
  sslkey: /etc/docker/registry/ssl/client-key.pem
  sslrootcert: /etc/docker/registry/ssl/server-ca.pem
  {{- end }}
  {{- if .Values.database.connecttimeout }}
  connecttimeout: {{ .Values.database.connecttimeout }}
  {{- end }}
  {{- if .Values.database.draintimeout }}
  draintimeout: {{ .Values.database.draintimeout }}
  {{- end }}
  {{- if .Values.database.preparedstatements }}
  preparedstatements: true
  {{- end }}
  {{- if .Values.database.pool }}
  pool:
    {{- if .Values.database.pool.maxidle }}
    maxidle: {{ .Values.database.pool.maxidle }}
    {{- end }}
    {{- if .Values.database.pool.maxopen }}
    maxopen: {{ .Values.database.pool.maxopen }}
    {{- end }}
    {{- if .Values.database.pool.maxlifetime }}
    maxlifetime: {{ .Values.database.pool.maxlifetime }}
    {{- end }}
    {{- if .Values.database.pool.maxidletime }}
    maxidletime: {{ .Values.database.pool.maxidletime }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Return Registry's database secret entry as a projected volume
*/}}
{{- define "gitlab.registry.database.password.projectedVolume" -}}
- secret:
    name: {{ default (printf "%s-registry-database-password" .Release.Name) .Values.database.password.secret }}
    items:
      - key: {{ default "password" .Values.database.password.key }}
        path: database_password
{{- end -}}

{{/*
Return PostgreSQL SSL client certificate secret key
*/}}
{{- define "gitlab.registry.psql.ssl.clientCertificate" -}}
{{ default .Values.global.psql.ssl.serverCA .Values.database.ssl.clientCertificate | required "Missing required key name of SQL client certificate. Make sure to set `registry.database.ssl.clientCertificate`" }}
{{- end -}}

{{/*
Return PostgreSQL SSL client key secret key
*/}}
{{- define "gitlab.registry.psql.ssl.clientKey" -}}
{{ default .Values.global.psql.ssl.clientKey .Values.database.ssl.clientKey | required "Missing required key name of SQL client key file. Make sure to set `registry.database.ssl.clientKey`" }}
{{- end -}}

{{/*
Return PostgreSQL SSL server CA secret key
*/}}
{{- define "gitlab.registry.psql.ssl.serverCA" -}}
{{ default .Values.global.psql.ssl.serverCA .Values.database.ssl.serverCA | required "Missing required key name of SQL server certificate. Make sure to set `registry.database.ssl.serverCA`" }}
{{- end -}}

{{/*
Return PostgreSQL SSL secret name
*/}}
{{- define "gitlab.registry.psql.ssl.secret" -}}
{{ default .Values.global.psql.ssl.secret .Values.database.ssl.secret | required "Missing required secret containing SQL SSL certificates and keys. Make sure to set `registry.database.ssl.secret`" }}
{{- end -}}

{{/*
Returns the K8s Secret definition for a PostgreSQL mutual TLS connection.
*/}}
{{- define "gitlab.registry.psql.ssl" -}}
{{-   if or .Values.database.ssl .Values.global.psql.ssl }}
- secret:
    name: {{ include "gitlab.registry.psql.ssl.secret" . }}
    items:
      - key: {{ include "gitlab.registry.psql.ssl.clientCertificate" . }}
        path: ssl/client-certificate.pem
      - key: {{ include "gitlab.registry.psql.ssl.clientKey" . }}
        path: ssl/client-key.pem
      - key: {{ include "gitlab.registry.psql.ssl.serverCA" . }}
        path: ssl/server-ca.pem
{{-   end -}}
{{- end -}}
