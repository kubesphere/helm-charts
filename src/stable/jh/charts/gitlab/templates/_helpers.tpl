{{/* vim: set filetype=mustache: */}}

{{/*
Return the version tag used to fetch the GitLab images
Defaults to using the information from the chart appVersion field, but can be
overridden using the global.gitlabVersion field in values.
*/}}
{{- define "gitlab.versionTag" -}}
{{- template "gitlab.parseAppVersion" (dict "appVersion" (coalesce .Values.global.gitlabVersion .Chart.AppVersion) "prepend" "true") -}}
{{- end -}}

{{/*
Returns a image tag from the passed in app version or branchname
Usage:
{{ include "gitlab.parseAppVersion" (    \
     dict                                \
         "appVersion" .Chart.AppVersion  \
         "prepend" "false"               \
     ) }}
1. If the version is a semver version, we check the prepend flag.
   1. If it is true, we prepend a `v` and return `vx.y.z` image tag.
   2. If it is false, we do not prepend a `v` and just use the input version
2. Else we just use the version passed as the image tag
*/}}
{{- define "gitlab.parseAppVersion" -}}
{{- $appVersion := coalesce .appVersion "main-jh" -}}
{{- if regexMatch "^\\d+\\.\\d+\\.\\d+(-rc\\d+)?(-pre)?$" $appVersion -}}
{{-   if eq .prepend "true" -}}
{{-      printf "v%s" $appVersion -}}
{{-   else -}}
{{-      $appVersion -}}
{{-   end -}}
{{- else -}}
{{- $appVersion -}}
{{- end -}}
{{- end -}}

{{/*
Returns the image repository depending on the value of global.edition.

Used to switch the deployment from Enterprise Edition (default) to Community
Edition. If global.edition=ce, returns the Community Edition image repository
set in the Gitlab values.yaml, otherwise returns the Enterprise Edition
image repository.
*/}}
{{- define "image.repository" -}}
{{ index .Values "global" "jhImages" .Chart.Name "repository" }}
{{- end -}}

{{- define "gitlab.extraContainers" -}}
{{ tpl (default "" .Values.extraContainers) . }}
{{- end -}}

{{- define "gitlab.extraInitContainers" -}}
{{ tpl (default "" .Values.extraInitContainers) . }}
{{- end -}}

{{- define "gitlab.extraVolumes" -}}
{{ tpl (default "" .Values.extraVolumes) . }}
{{- end -}}

{{- define "gitlab.extraVolumeMounts" -}}
{{ tpl (default "" .Values.extraVolumeMounts) . }}
{{- end -}}

{{/*
Returns the extraEnv keys and values to inject into containers.

Global values will override any chart-specific values.
*/}}
{{- define "gitlab.extraEnv" -}}
{{- $allExtraEnv := merge (default (dict) .Values.extraEnv) .Values.global.extraEnv -}}
{{- range $key, $value := $allExtraEnv }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end -}}
{{- end -}}

{{/*
Detect whether to include internal Gitaly resources.
Returns `true` when:
  - Internal Gitaly is on
  AND
  - Either:
    - Praefect is off, or
    - Praefect is on, but replaceInternalGitaly is off
*/}}
{{- define "gitlab.gitaly.includeInternalResources" -}}
{{- if and .Values.global.gitaly.enabled (or (not .Values.global.praefect.enabled) (and .Values.global.praefect.enabled (not .Values.global.praefect.replaceInternalGitaly))) -}}
{{-   true }}
{{- end -}}
{{- end -}}
