{{/* vim: set filetype=mustache: */}}

{{/*
Return the registry authEndpoint
Defaults to the globally set gitlabHostname if an authEndpoint hasn't been provided
to the chart
*/}}
{{- define "registry.authEndpoint" -}}
{{- if .Values.authEndpoint -}}
{{- .Values.authEndpoint -}}
{{- else -}}
{{- template "gitlab.gitlab.url" . -}}
{{- end -}}
{{- end -}}

{{/*
Returns the hostname.
If the hostname is set in `global.hosts.registry.name`, that will be returned,
otherwise the hostname will be assembed using `registry` as the prefix, and the `gitlab.assembleHost` function.
*/}}
{{- define "registry.hostname" -}}
{{- coalesce .Values.global.hosts.registry.name (include "gitlab.assembleHost"  (dict "name" "registry" "context" . )) -}}
{{- end -}}

{{/*
Returns the secret name for the Secret containing the TLS certificate and key.
Uses `ingress.tls.secretName` first and falls back to `global.ingress.tls.secretName`
if there is a shared tls secret for all ingresses.
*/}}
{{- define "registry.tlsSecret" -}}
{{- $defaultName := (dict "secretName" "") -}}
{{- if .Values.global.ingress.configureCertmanager -}}
{{- $_ := set $defaultName "secretName" (printf "%s-registry-tls" .Release.Name) -}}
{{- else -}}
{{- $_ := set $defaultName "secretName" (include "gitlab.wildcard-self-signed-cert-name" .) -}}
{{- end -}}
{{- pluck "secretName" .Values.ingress.tls .Values.global.ingress.tls $defaultName | first -}}
{{- end -}}

{{/*
Returns the minio URL.
If `registry.redirect` is set to `true` it will return the external domain name of minio, 
e.g. `https://minio.example.com`, otherwise it will fallback to the internal minio service
URL, e.g. `http://minio-svc:9000`.

For external domain name, if `global.hosts.https` or `global.hosts.minio.https` is true,
it uses https, otherwise http. Calls into the `gitlab.minio.hostname` function for the
hostname part of the url.
*/}}
{{- define "registry.minio.url" -}}
{{- if .Values.minio.redirect -}}
  {{- if or .Values.global.hosts.https .Values.global.hosts.minio.https -}}
  {{-   printf "https://%s" (include "gitlab.minio.hostname" .) -}}
  {{- else -}}
  {{-   printf "http://%s" (include "gitlab.minio.hostname" .) -}}
  {{- end -}}
{{- else -}}
  {{- include "gitlab.minio.endpoint" . -}}
{{- end -}}
{{- end -}}

{{/*
Returns the nginx ingress class
*/}}
{{- define "registry.ingressclass" -}}
{{- pluck "class" .Values.global.ingress (dict "class" (printf "%s-nginx" .Release.Name)) | first -}}
{{- end -}}

{{/*
Populate registry notifications
*/}}
{{- define "registry.notifications.config" -}}
{{- if $.Values.global.registry.notifications }}
notifications:
  {{- if $.Values.global.registry.notifications.events }}
  events:
    {{- toYaml $.Values.global.registry.notifications.events | nindent 4 }}
  {{- end -}}
  {{- if $.Values.global.registry.notifications.endpoints }}
  endpoints:
    {{- range $endpoint := $.Values.global.registry.notifications.endpoints -}}
      {{- if $endpoint.name -}}
        {{- $headers := pluck "headers" $endpoint | first -}}
        {{- $endpoint = omit $endpoint "headers" }}
        {{- toYaml (list $endpoint) | nindent 4 }}
        {{- if $headers }}
      headers:
          {{- range $header, $value := $headers -}}
            {{- if kindIs "map" $value -}}
              {{- if hasKey $value "secret" }}
        {{ $header }}: SECRET_{{ $value.secret }}_{{ default "value" $value.key }}
              {{- end -}}
            {{- else }}
        {{ $header }}: {{ $value }}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Individual secret items to be used as volumes
Usage:
{{ include "registry.notifications.secrets.item " ( \
     dict
         "value" $value
         "fileName" $fileName
     ) }}
*/}}
{{- define "registry.notifications.secrets.item" -}}
- secret:
    name: {{ .value.secret }}
    items:
      - key: {{ default "value" .value.key }}
        path: notifications/SECRET_{{ .fileName }}
{{- end }}

{{/*
Sensitive registry notification headers mounted as secrets
*/}}
{{- define "registry.notifications.secrets" -}}
{{- if $.Values.global.registry.notifications }}
  {{- $uniqSecrets := list -}}
  {{- range $endpoint := $.Values.global.registry.notifications.endpoints -}}
    {{- if and $endpoint.name $endpoint.headers -}}
      {{- range $header, $value := $endpoint.headers -}}
        {{- if kindIs "map" $value -}}
          {{- if hasKey $value "secret" }}
            {{- $fileName := printf "%s_%s" $value.secret (default "value" $value.key) -}}
            {{- if not (has $fileName $uniqSecrets) }}
              {{- $uniqSecrets = append $uniqSecrets $fileName }}
{{ include "registry.notifications.secrets.item" (dict "value" $value "fileName" $fileName) }}
            {{- end -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}
