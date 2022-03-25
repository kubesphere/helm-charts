{{/*
Generates Content Security Policy configuration.

Usage:
{{ include "gitlab.appConfig.content_security_policy" . }}
*/}}
{{- define "gitlab.appConfig.content_security_policy" -}}
content_security_policy:
  {{- with .contentSecurityPolicy }}
  enabled: {{ eq .enabled true }}
  report_only: {{ .report_only }}
  directives: {{ toJson .directives }}
  {{- end -}}
{{- end -}}{{/* "gitlab.appConfig.content_security_policy" */}}
