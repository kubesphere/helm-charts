{{/* vim: set filetype=mustache: */}}
{{/*
Define the version of csi qingcloud driver.
*/}}
{{- define "driver.version" -}}
{{- coalesce .Values.driver.tag (printf "v%s" .Chart.AppVersion) -}}
{{- end -}}

{{- define "registrar.version" -}}
{{- coalesce .Values.registrar.tag (printf "v%s" .Chart.AppVersion) -}}
{{- end -}}
