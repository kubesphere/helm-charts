{{/*
Generates a templated config for terraform_state key in gitlab.yml.

Usage:
{{ include "gitlab.appConfig.terraformState.configuration" ( \
     dict                                                    \
         "config" .Values.path.to.terraform_state.config      \
         "context" $                                         \
     ) }}
*/}}
{{- define "gitlab.appConfig.terraformState.configuration" -}}
terraform_state:
  enabled: {{ if kindIs "bool" .config.enabled }}{{ eq .config.enabled true }}{{ end }}
  {{- if not .context.Values.global.appConfig.object_store.enabled }}
  {{-   include "gitlab.appConfig.objectStorage.configuration" (dict "name" "terraform_state" "config" .config "context" .context) | nindent 2 }}
  {{- end }}
{{- end -}}{{/* "gitlab.appConfig.terraformState.configuration" */}}
