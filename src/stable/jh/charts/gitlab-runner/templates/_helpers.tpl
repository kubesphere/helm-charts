{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitlab-runner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gitlab-runner.fullname" -}}
{{-   if .Values.fullnameOverride -}}
{{-     .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{-   else -}}
{{-     $name := default .Chart.Name .Values.nameOverride -}}
{{-     printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{-   end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gitlab-runner.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the secret containing the tokens
*/}}
{{- define "gitlab-runner.secret" -}}
{{- default (include "gitlab-runner.fullname" .) .Values.runners.secret | quote -}}
{{- end -}}

{{/*
Define the name of the s3 cache secret
*/}}
{{- define "gitlab-runner.cache.secret" -}}
{{- if .Values.runners.cache.secretName -}}
{{- .Values.runners.cache.secretName | quote -}}
{{- end -}}
{{- end -}}

{{/*
Template for outputing the gitlabUrl
*/}}
{{- define "gitlab-runner.gitlabUrl" -}}
{{- .Values.gitlabUrl | quote -}}
{{- end -}}

{{/*
Template runners.cache.s3ServerAddress in order to allow overrides from external charts.
*/}}
{{- define "gitlab-runner.cache.s3ServerAddress" }}
{{- default "" .Values.runners.cache.s3ServerAddress | quote -}}
{{- end -}}

{{/*
Define the image, using .Chart.AppVersion and GitLab Runner image as a default value
*/}}
{{- define "gitlab-runner.image" }}
{{-   $appVersion := ternary "bleeding" (print "v" .Chart.AppVersion) (eq .Chart.AppVersion "bleeding") -}}
{{-   $image := printf "gitlab/gitlab-runner:alpine-%s" $appVersion -}}
{{-   default $image .Values.image }}
{{- end -}}

{{/*
Define the server session timeout, using 1800 as a default value
*/}}
{{- define "gitlab-runner.server-session-timeout" }}
{{-   default 1800 .Values.sessionServer.timeout }}
{{- end -}}

{{/*
Define the server session internal port, using 9000 as a default value
*/}}
{{- define "gitlab-runner.server-session-external-port" }}
{{-   default 9000 .Values.sessionServer.externalPort }}
{{- end -}}

{{/*
Define the server session external port, using 8093 as a default value
*/}}
{{- define "gitlab-runner.server-session-internal-port" }}
{{-   default 8093 .Values.sessionServer.internalPort }}
{{- end -}}

{{/*
Unregister runners on pod stop
*/}}
{{- define "gitlab-runner.unregisterRunners" -}}
{{- if or (and (hasKey .Values "unregisterRunners") .Values.unregisterRunners) (and (not (hasKey .Values "unregisterRunners")) .Values.runnerRegistrationToken) -}}
lifecycle:
  preStop:
    exec:
      command: ["/entrypoint", "unregister", "--all-runners"]
{{- end -}}
{{- end -}}
