{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ks-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ks-core.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
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
{{- define "ks-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ks-core.labels" -}}
helm.sh/chart: {{ include "ks-core.chart" . }}
{{ include "ks-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ks-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ks-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ks-core.serviceAccountName" -}}
{{- default "kubesphere" .Values.serviceAccount.name }}
{{- end }}

{{- define "portal.host" -}}
{{- if and .Values.portal.https (.Values.portal.https).port }}
{{- if eq (int .Values.portal.https.port) 443 }}
{{- printf "https://%s" .Values.portal.hostname }}
{{- else }}
{{- printf "https://%s:%d" .Values.portal.hostname (int .Values.portal.https.port) }}
{{- end }}
{{- else }}
{{- if eq (int .Values.portal.http.port) 80 }}
{{- printf "http://%s" .Values.portal.hostname }}
{{- else }}
{{- printf "http://%s:%d" .Values.portal.hostname (int .Values.portal.http.port) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "jwtSecret" -}}
{{- if eq .Values.authentication.issuer.jwtSecret "" }}
{{- with lookup "v1" "ConfigMap" (printf "%s" .Release.Namespace) "kubesphere-config" }}
{{- with (fromYaml (index .data "kubesphere.yaml")) }}
{{- if and .authentication (.authentication).jwtSecret }}
{{- .authentication.jwtSecret }}
{{- else if and .authentication (.authentication).issuer ((.authentication).issuer).jwtSecret }}
{{- .authentication.issuer.jwtSecret }}
{{- else }}
{{- $.Values.authentication.issuer.jwtSecret | default (randAlphaNum 32 ) }}
{{- end }}
{{- else }}
{{- $.Values.authentication.issuer.jwtSecret | default (randAlphaNum 32 ) }}
{{- end }}
{{- else }}
{{- $.Values.authentication.issuer.jwtSecret | default (randAlphaNum 32 ) }}
{{- end }}
{{- else }}
{{- .Values.authentication.issuer.jwtSecret }}
{{- end }}
{{- end }}

{{- define "role" -}}
{{- if eq .Values.role "" }}
{{- with lookup "v1" "ConfigMap" (printf "%s" .Release.Namespace) "kubesphere-config" }}
{{- with (fromYaml (index .data "kubesphere.yaml")) }}
{{- if and .multicluster (.multicluster).clusterRole }}
{{- if eq .multicluster.clusterRole "none" }}
{{- "host" }}
{{- else }}
{{- .multicluster.clusterRole }}
{{- end }}
{{- else }}
{{- $.Values.role | default "host" }}
{{- end }}
{{- else }}
{{- $.Values.role | default "host" }}
{{- end }}
{{- else }}
{{- $.Values.role | default "host" }}
{{- end }}
{{- else }}
{{- .Values.role }}
{{- end }}
{{- end }}

{{/*
Returns user's password or use default
*/}}
{{- define "getOrDefaultPass" }}
{{- if not .Values.authentication.adminPassword -}}
{{- printf "$2a$10$zcHepmzfKPoxCVCYZr5K7ORPZZ/ySe9p/7IUb/8u./xHrnSX2LOCO" -}}
{{- else -}}
{{- printf "%s" .Values.authentication.adminPassword -}}
{{- end -}}
{{- end }}

{{/*
Returns user's password or use default. Used by NOTES.txt
*/}}
{{- define "printOrDefaultPass" }}
{{- if not .Values.authentication.adminPassword -}}
{{- printf "P@88w0rd" -}}
{{- else -}}
{{- printf "%s" .Values.authentication.adminPassword -}}
{{- end -}}
{{- end }}

{{- define "getNodeAddress" -}}
{{- $address := "127.0.0.1"}}
{{- with $nodes := lookup "v1" "Node" "" "" }}
{{- $node := first $nodes.items -}}
{{- range $k, $v := $node.status.addresses }}
  {{- if (eq $v.type "InternalIP") }}
     {{- $address = $v.address }}
  {{- end }}
{{- end }}
{{- else }}
{{- end }}
{{- printf "%s" $address }}
{{- end }}
