{{/*
deployment and daemonset
*/}}
{{- define "porter.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "manager.application" -}}
{{- "manager" -}}
{{- end -}}

{{- define "manager.name" -}}
{{- printf "%s-%s" .Chart.Name (include "manager.application" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent.application" -}}
{{- "agent" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "agent.name" -}}
{{- printf "%s-%s" .Chart.Name (include "agent.application" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "manager.matchLabels" -}}
app: {{ template "manager.name" . }}
control-plane: {{ template "manager.name" . }}
{{- end -}}

{{- define "agent.matchLabels" -}}
app: {{ template "agent.name" . }}
{{- end -}}

{{/*
role, cluster role and role binding
*/}}

{{- define "role.name" -}}
{{- "leader-election-role" -}}
{{- end -}}

{{- define "manager.clusterrole" -}}
{{- printf "%s-%s" (include "manager.application" .) "role" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "manager.clusterrolebinding" -}}
{{- printf "%s%s" (include "manager.clusterrole" .) "binding" | trunc 63 | trimSuffix "-" -}}
{{- end -}}