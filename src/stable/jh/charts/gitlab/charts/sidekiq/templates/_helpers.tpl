{{/* vim: set filetype=mustache: */}}

{{/*
Returns the extraEnv keys and values to inject into containers. Allows
pod-level values for extraEnv.

Takes a dict with `local` being the pod-level configuration and `parent`
being the chart-level configuration.

Pod values take precedence, then chart values, and finally global
values.
*/}}
{{- define "sidekiq.podExtraEnv" -}}
{{- $allExtraEnv := merge (default (dict) .local.extraEnv) (default (dict) .context.Values.extraEnv) .context.Values.global.extraEnv -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}

{{/*
Returns a list of _common_ labels to be shared across all
Sidekiq deployments and other shared objects, otherwise
known as pods currently.
*/}}
{{- define "sidekiq.commonLabels" -}}
{{- $commonPodLabels := merge (default (dict) .pod) (default (dict) .global) -}}
{{- range $key, $value := $commonPodLabels }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
Returns a list of _pod_ labels to be shared across all
Sidekiq deployments, otherwise known as pods currently.
*/}}
{{- define "sidekiq.podLabels" -}}
{{- $commonPodLabels := default (dict) .pod -}}
{{- range $key, $value := $commonPodLabels }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
Create a datamodel for our common labels
*/}}
{{- define "sidekiq.pod.common.labels" -}}
{{- $default := dict "labels" (dict) -}}
{{- $_ := set . "common" (merge (default (dict) .common) $default) -}}
{{- end -}}
