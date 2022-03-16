{{/*
Generates sentry configuration.

Usage:
{{ include "gitlab.appConfig.sentry.configuration" $ }}
*/}}
{{- define "gitlab.appConfig.sentry.configuration" -}}
sentry:
  enabled: {{ eq $.Values.global.appConfig.sentry.enabled true }}
  dsn: {{ $.Values.global.appConfig.sentry.dsn }}
  clientside_dsn: {{ $.Values.global.appConfig.sentry.clientside_dsn }}
  environment: {{ $.Values.global.appConfig.sentry.environment }}
{{- end -}}{{/* "gitlab.appConfig.sentry.configuration" */}}
