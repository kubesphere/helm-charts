{{/*
Return the registry's profiling credentials secret key
*/}}
{{- define "gitlab.registry.profiling.stackdriver.credentials.key" -}}
{{- default "credentials" .Values.profiling.stackdriver.credentials.key | quote -}}
{{- end -}}

{{/*
Construct a default registry profiling service name, if not supplied
*/}}
{{- define "gitlab.registry.profiling.stackdriver.service" -}}
{{- default (include "registry.fullname" .) .Values.profiling.stackdriver.service | quote -}}
{{- end -}}
