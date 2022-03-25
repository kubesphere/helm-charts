{{- define "gitlab.gitaly.storageNames" -}}
{{- range (coalesce $.Values.internal.names $.Values.global.gitaly.internal.names) }} {{ . | quote }}, {{- end }}
{{- end -}}

{{- define "gitlab.praefect.gitaly.storageNames" -}}
{{- range $_, $storage := $.Values.global.praefect.virtualStorages -}}
{{ range until ($storage.gitalyReplicas | int) }} {{ printf "%s-gitaly-%s-%d" $.Release.Name $storage.name . | quote }}, {{- end }}
{{- end -}}
{{- end -}}