{{/*
Expand the name of the chart.
*/}}
{{- define "operator.name" -}}
{{- default "operator" .Values.operator.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "operator.fullname" -}}
{{- if .Values.operator.fullnameOverride }}
{{- .Values.operator.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "operator" .Values.operator.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "operator.labels" -}}
helm.sh/chart: {{ include "operator.chart" . }}
{{ include "operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create }}
{{- default (include "operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.operator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Operator image
*/}}
{{- define "operator.image" -}}
{{ .Values.global.registry }}{{ .Values.operator.image.repository | default "iomesh/operator"}}:{{ .Values.operator.image.tag | default .Chart.Version }}
{{- end }}

{{/*
Secret's name of certs
*/}}
{{- define "iomesh.webhook.cert" -}}
{{- printf "iomesh-webhook-cert" -}}
{{- end -}}
{{- define "iomesh.apiserver.cert" -}}
{{- printf "iomesh-apiserver-cert" -}}
{{- end -}}

{{/*
E2E test
*/}}
{{- define "operator.extraPersistentVolumeClaim" -}}
{{- with .Values.operator.extraPersistentVolumeClaim }}
---
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "iomesh.name" -}}
{{- default .Chart.Name .Values.iomesh.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iomesh.fullname" -}}
{{- if .Values.iomesh.fullnameOverride }}
{{- .Values.iomesh.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.iomesh.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iomesh.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iomesh.labels" -}}
helm.sh/chart: {{ include "iomesh.chart" . }}
{{ include "iomesh.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iomesh.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iomesh.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "iomesh.operatorVersion" -}}
{{ .Values.iomesh.operatorVersion | default .Chart.Version }}
{{- end }}

{{/*
App Edition
*/}}
{{- define "iomesh.edition" -}}
{{- if .Values.iomesh.edition -}}
{{ .Values.iomesh.edition }}
{{- else -}}
community
{{- end }}
{{- end }}

{{/*
App Version
*/}}
{{- define "iomesh.version" -}}
{{- if eq .Values.iomesh.platform "hygon_x86_64" -}}
{{ .Values.iomesh.appVersion | default .Chart.AppVersion }}-{{ include "iomesh.edition" . }}-hygon
{{- else -}}
{{ .Values.iomesh.appVersion | default .Chart.AppVersion }}-{{ include "iomesh.edition" . }}
{{- end }}
{{- end }}


{{/*
meta image
*/}}
{{- define "iomesh.metaImage" -}}
{{ .Values.global.registry }}{{ .Values.iomesh.meta.image.repository }}:{{ .Values.iomesh.meta.image.tag | default (include "iomesh.version" .) }}
{{- end }}


{{/*
chunk image
*/}}
{{- define "iomesh.chunkImage" -}}
{{ .Values.global.registry }}{{ .Values.iomesh.chunk.image.repository }}:{{ .Values.iomesh.chunk.image.tag | default (include "iomesh.version" .) }}
{{- end }}

{{/*
iSCSI redirector image
*/}}
{{- define "iomesh.redirectorImage" -}}
{{ .Values.global.registry }}{{ .Values.iomesh.redirector.image.repository }}:{{ .Values.iomesh.redirector.image.tag | default (include "iomesh.version" .) }}
{{- end }}
