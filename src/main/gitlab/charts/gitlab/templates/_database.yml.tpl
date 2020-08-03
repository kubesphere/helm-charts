{{/* ######## Rails database related templates */}}
{{/*
Returns the contents of the `database.yml` blob for Rails pods
*/}}
{{- define "gitlab.database.yml" -}}
production:
  adapter: postgresql
  encoding: unicode
  database: {{ template "gitlab.psql.database" . }}
  username: {{ template "gitlab.psql.username" . }}
  password: "<%= File.read("/etc/gitlab/postgres/psql-password").strip.dump[1..-2] %>"
  host: {{ include "gitlab.psql.host" . | quote }}
  port: {{ template "gitlab.psql.port" . }}
  pool: {{ template "gitlab.psql.pool" . }}
  prepared_statements: {{ template "gitlab.psql.preparedStatements" . }}
  {{- include "gitlab.database.loadBalancing" . | nindent 2 }}
  {{- include "gitlab.psql.ssl.config" . | nindent 2 }}
{{- end -}}

{{/*
Returns the contents of `load_balancing` section of database.yml

See https://docs.gitlab.com/ee/administration/database_load_balancing.html#enabling-load-balancing

Note: Many `if` used here, allowing Rails to provide defaults inside the codebase.
*/}}
{{- define "gitlab.database.loadBalancing" -}}
{{- with default .Values.global.psql .Values.psql -}}
{{-   if kindIs "map" .load_balancing -}}
load_balancing:
  {{-   if kindIs "slice" .load_balancing.hosts }}
  hosts:
    {{- toYaml .load_balancing.hosts | nindent 2 }}
  {{-   else if kindIs "map" .load_balancing.discover }}
  discover:
    {{- with .load_balancing.discover -}}
    {{-   if index . "nameserver" }}
    nameserver: {{ .nameserver }}
    {{- end }}
    record: {{ .record | required "`psql.load_balancing.discover` requires `record` to be provided." | quote }}
    {{-   if index . "record_type" }}
    record_type: {{ .record_type | quote }}
    {{- end }}
    {{-   if index . "port" }}
    port: {{ .port | int }}
    {{- end }}
    {{-   if index . "interval" }}
    interval: {{ .interval | int }}
    {{- end }}
    {{-   if index . "disconnect_timeout" }}
    disconnect_timeout: {{ .disconnect_timeout | int }}
    {{- end }}
    {{-   if index . "use_tcp" }}
    use_tcp: {{ empty .use_tcp | not }}
    {{-   end -}}
    {{- end -}}
  {{-   end }}
  {{-   if index .load_balancing "max_replication_difference" }}
  max_replication_difference: {{ .load_balancing.max_replication_difference | int }}
  {{-  end }}
  {{-  if index .load_balancing "max_replication_lag_time" }}
  max_replication_lag_time: {{ .load_balancing.max_replication_lag_time | int }}
  {{-  end }}
  {{-  if index .load_balancing "replica_check_interval" }}
  replica_check_interval: {{ .load_balancing.replica_check_interval | int }}
  {{-  end }}
{{-   end -}}
{{- end -}}
{{- end -}}