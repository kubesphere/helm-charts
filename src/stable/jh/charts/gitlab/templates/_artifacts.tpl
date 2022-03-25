{{/*
Generates a templated config for artifacts key in gitlab.yml.

Usage:
{{ include "gitlab.appConfig.artifacts.configuration" ( \
     dict                                               \
         "config" .Values.path.to.artifacts.config      \
         "context" $                                    \
     ) }}
*/}}
{{- define "gitlab.appConfig.artifacts.configuration" -}}
artifacts:
  enabled: {{ if kindIs "bool" .config.enabled }}{{ eq .config.enabled true }}{{ end }}
  {{- if not .context.Values.global.appConfig.object_store.enabled }}
  {{-   include "gitlab.appConfig.objectStorage.configuration" (dict "name" "artifacts" "config" .config "context" .context) | nindent 2 }}
  {{- end }}
{{- end -}}{{/* "gitlab.appConfig.artifacts.configuration" */}}
