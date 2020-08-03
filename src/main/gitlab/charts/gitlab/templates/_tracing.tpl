{{/* ######### Tracing templates */}}

{{- define "gitlab.tracing.env" -}}
{{- if .Values.global.tracing.connection.string }}
- name: GITLAB_TRACING
  value: {{ .Values.global.tracing.connection.string | quote }}
{{- end -}}
{{- end -}}
