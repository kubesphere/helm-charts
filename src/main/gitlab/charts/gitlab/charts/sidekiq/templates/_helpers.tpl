{{/*
Returns the extraEnv keys and values to inject into containers. Allows
pod-level values for extraEnv.

Takes a dict with `local` being the pod-level configuration and `parent`
being the chart-level configuration.

Pod values take precedence, then chart values, and finally global
values.
*/}}
{{- define "sidekiq.podExtraEnv" -}}
{{- $allExtraEnv := merge (default (dict) .local.extraEnv) (default (dict) .parent.Values.extraEnv) .parent.Values.global.extraEnv -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}
