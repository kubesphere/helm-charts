{{/*
Return the default praefect storage line for gitlab.yml
*/}}
{{- define "gitlab.praefect.storages" -}}
{{- $scheme := "tcp" -}}
{{- $port := include "gitlab.praefect.externalPort" $ -}}
{{- if $.Values.global.praefect.tls.enabled -}}
{{- $scheme = "tls" -}}
{{- $port = include "gitlab.praefect.tls.externalPort" $ -}}
{{- end }}
{{- range $.Values.global.praefect.virtualStorages }}
{{ .name }}:
  path: /var/opt/gitlab/repo
  gitaly_address: {{ printf "%s" $scheme }}://{{ template "gitlab.praefect.serviceName" $ }}.{{$.Release.Namespace}}.svc:{{ $port }}
  gitaly_token: <%= File.read('/etc/gitlab/gitaly/gitaly_token_praefect').strip.to_json %>
{{- end }}
{{- end -}}

{{/*
Return the resolvable name of the praefect service
*/}}
{{- define "gitlab.praefect.serviceName" -}}
{{- coalesce .Values.serviceName .Values.global.praefect.serviceName (printf "%s-praefect" $.Release.Name) -}}
{{- end -}}

{{/*
Return the service name for Gitaly when Praefect is enabled

Call:

```
include "gitlab.praefect.gitaly.serviceName" (dict "context" $ "name" .name)
```
*/}}
{{- define "gitlab.praefect.gitaly.serviceName" -}}
{{ include "gitlab.gitaly.serviceName" .context }}-{{ .name }}
{{- end -}}

{{/*
Return the qualified service name for a given Gitaly pod.

Call:

```
include "gitlab.praefect.gitaly.qualifiedServiceName" (dict "context" $ "index" $i "name" .name)
```
*/}}
{{- define "gitlab.praefect.gitaly.qualifiedServiceName" -}}
{{- $name := include "gitlab.praefect.gitaly.serviceName" (dict "context" .context "name" .name) -}}
{{ $name }}-{{ .index }}.{{ $name }}
{{- end -}}
