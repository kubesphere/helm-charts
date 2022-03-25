{{/*
Generates a templated config for uploads key in gitlab.yml.

Usage:
{{ include "gitlab.appConfig.uploads.configuration" ( \
     dict                                             \
         "config" .Values.path.to.uploads.config      \
         "context" $                                  \
     ) }}
*/}}
{{- define "gitlab.appConfig.uploads.configuration" -}}
uploads:
  enabled: {{ if kindIs "bool" .config.enabled }}{{ eq .config.enabled true }}{{ end }}
  {{- if not .context.Values.global.appConfig.object_store.enabled }}
  {{-   include "gitlab.appConfig.objectStorage.configuration" (dict "name" "uploads" "config" .config "context" .context) | nindent 2 }}
  {{- end }}
{{- end -}}{{/* "gitlab.appConfig.uploads.configuration" */}}
