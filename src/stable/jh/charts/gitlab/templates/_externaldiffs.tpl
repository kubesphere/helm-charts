{{/*
Generates a templated config for external_diffs key in gitlab.yml.

Usage:
{{ include "gitlab.appConfig.external_diffs.configuration" ( \
     dict                                                    \
         "config" .Values.path.to.external_diffs.config      \
         "context" $                                         \
     ) }}
*/}}
{{- define "gitlab.appConfig.external_diffs.configuration" -}}
external_diffs:
  enabled: {{ if kindIs "bool" .config.enabled }}{{ eq .config.enabled true }}{{ end }}
  when: {{ .config.when }}
  {{- if not .context.Values.global.appConfig.object_store.enabled }}
  {{-   include "gitlab.appConfig.objectStorage.configuration" (dict "name" "external_diffs" "config" .config "context" .context) | nindent 2 }}
  {{- end -}}
{{- end -}}{{/* "gitlab.appConfig.external_diffs.configuration" */}}
