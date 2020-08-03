{{/* ######### Gitaly related templates */}}

{{/*
Return the gitaly secret name
Preference is local, global, default (`gitaly-secret`)
*/}}
{{- define "gitlab.gitaly.authToken.secret" -}}
{{- coalesce .Values.global.gitaly.authToken.secret (printf "%s-gitaly-secret" .Release.Name) | quote -}}
{{- end -}}

{{/*
Return the gitaly secret key
Preference is local, global, default (`token`)
*/}}
{{- define "gitlab.gitaly.authToken.key" -}}
{{- coalesce .Values.global.gitaly.authToken.key "token" | quote -}}
{{- end -}}

{{/*
Return the gitaly TLS secret name
*/}}
{{- define "gitlab.gitaly.tls.secret" -}}
{{- default (printf "%s-gitaly-tls" .Release.Name) .Values.global.gitaly.tls.secretName | quote -}}
{{- end -}}

{{/*
Return the gitaly service name

Order of operations:
- chart-local gitaly service name override
- global gitaly service name override
- derived from chart name
*/}}
{{- define "gitlab.gitaly.serviceName" -}}
{{- coalesce ( .Values.gitaly.serviceName ) .Values.global.gitaly.serviceName (include "gitlab.other.fullname" (dict "context" . "chartName" "gitaly" )) -}}
{{- end -}}

{{/*
Return a qualified gitaly service name, for direct access to the gitaly headless service endpoint of a pod.

Call:

```
{{- include "gitlab.gitaly.qualifiedServiceName" (dict "context" . "index" $i)-}}
```
*/}}
{{- define "gitlab.gitaly.qualifiedServiceName" -}}
{{- $name := include "gitlab.gitaly.serviceName" .context -}}
{{ include "gitlab.other.fullname" (dict "context" .context "chartName" "gitaly" ) }}-{{ .index }}.{{ $name }}
{{- end -}}
