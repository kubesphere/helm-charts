{{/*
Expand the name of the chart.
*/}}
{{- define "porter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the chart plus release name (used by the chart label)
*/}}
{{- define "porter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "porter.namespace" -}}
{{- .Release.Namespace -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "porter.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "porter.labels" -}}
app.kubernetes.io/name: {{ include "porter.name" . }}
helm.sh/chart: {{ include "porter.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "manager.selectorLabels" -}}
app.kubernetes.io/name: porter-manager
app.kubernetes.io/instance: {{ .Release.Name }}
app: porter-manager
{{- end -}}

{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: porter-agent
app.kubernetes.io/instance: {{ .Release.Name }}
app: porter-agent
{{- end -}}

{{- define "porter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "porter.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}