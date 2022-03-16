{{/* ######## GitLab Pages related templates */}}

{{/*
Returns the pages entry for gitlab.yml of Rails-based containers.
*/}}
{{- define "gitlab.pages.config" -}}
pages:
  enabled: {{ or (eq $.Values.global.pages.enabled true) (not (empty $.Values.global.pages.host)) }}
  access_control: {{ eq $.Values.global.pages.accessControl true }}
  artifacts_server: {{ eq $.Values.global.pages.artifactsServer true }}
  path: {{ default "/srv/gitlab/shared/pages" $.Values.global.pages.path }}
  host: {{ template "gitlab.pages.hostname" $ }}
  port: {{ default ( eq "true" (include "gitlab.pages.https" $) | ternary 443 80 ) $.Values.global.pages.port | int }}
  https: {{ eq "true" (include "gitlab.pages.https" $) }}
  secret_file: /etc/gitlab/pages/secret
  external_http: {{ not (empty $.Values.global.pages.externalHttp) }}
  external_https: {{ not (empty $.Values.global.pages.externalHttps) }}
  {{- if not $.Values.global.appConfig.object_store.enabled }}
  {{-   include "gitlab.appConfig.objectStorage.configuration" (dict "name" "pages" "config" $.Values.global.pages.objectStore "context" $ ) | nindent 2 }}
  {{- end }}
  local_store:
    enabled: {{ $.Values.global.pages.localStore.enabled }}
    path: {{ $.Values.global.pages.localStore.path }}
{{- end -}}

{{- define "gitlab.pages.mountSecrets" }}
{{- if or (eq $.Values.global.pages.enabled true) (not (empty $.Values.global.pages.host)) }}
- secret:
    name: {{ template "gitlab.pages.apiSecret.secret" . }}
    items:
      - key: {{ template "gitlab.pages.apiSecret.key" . }}
        path: pages/secret
{{- end -}}
{{- end -}}

{{/*
Returns the Pages hostname.
If the hostname is set in `global.hosts.pages.name`, that will be returned,
otherwise the hostname will be assembed using `pages` as the prefix, and the `gitlab.assembleHost` function.
*/}}
{{- define "gitlab.pages.hostname" -}}
{{- coalesce $.Values.global.pages.host $.Values.global.hosts.pages.name (include "gitlab.assembleHost"  (dict "name" "pages" "context" . )) -}}
{{- end -}}

{{/*
Returns consolidated `pages.https` as "true" or ""

This pulls together, in this order, accounting for `false` boolean values:
- if global.pages.https is set, use that.
- if global.hosts.pages.https is set, use that.
- if global.hosts.https is set use that.
- if somehow all are unset, return `true`

See gitlab.boolean.local @ /templates/_boolean.tpl
*/}}
{{- define "gitlab.pages.https" -}}
{{- $global :=  pluck "https" $.Values.global.hosts.pages $.Values.global.hosts | first -}}
{{- include "gitlab.boolean.local" (dict "global" $global "local" $.Values.global.pages.https "default" true) -}}
{{- end -}}

{{/*
Return the Pages artifacts server URL.
If the chart Pages artifacts server URL is provided, it will use that,
otherwise it will fallback to the API v4 endpoint of GitLab domain.
*/}}
{{- define "gitlab.pages.artifactsServer" -}}
{{- if .Values.artifactsServerUrl -}}
{{ .Values.artifactsServerUrl }}
{{- else -}}
{{ template "gitlab.pages.internalGitlabServer" . }}/api/v4
{{- end -}}
{{- end -}}

{{/*
Return the GitLab server URL Pages should contact.
If the chart Pages GitLab server URL is provided, it will use that,
otherwise it will fallback to the public GitLab URL of GitLab.
*/}}
{{- define "gitlab.pages.gitlabServer" -}}
{{- if .Values.gitlabServer -}}
{{ .Values.gitlabServer }}
{{- else -}}
{{- template "gitlab.gitlab.url" . }}
{{- end -}}
{{- end -}}

{{/*
Return the Internal GitLab server URL Pages should contact.
If the chart Pages GitLab server URL is provided, it will use that,
otherwise it will fallback to the Service of the GitLab Workhorse deployed in the
cluster.
*/}}
{{- define "gitlab.pages.internalGitlabServer" -}}
{{- if .Values.internalGitlabServer -}}
{{ .Values.internalGitlabServer }}
{{- else -}}
http://{{ template "gitlab.workhorse.host" . }}:{{ template "gitlab.workhorse.port" . }}
{{- end -}}
{{- end -}}

{{/*
Return the metrics annotations for GitLab Pages
*/}}
{{- define "gitlab.pages.metricsAnnotations" -}}
{{- if .Values.metrics.annotations -}}
{{- toYaml .Values.metrics.annotations }}
{{- else -}}
gitlab.com/prometheus_scrape: "true"
gitlab.com/prometheus_port: {{ .Values.metrics.port | quote }}
gitlab.com/prometheus_path: "/metrics"
prometheus.io/scrape: "true"
prometheus.io/port: {{ .Values.metrics.port | quote }}
prometheus.io/path: "/metrics"
{{- end -}}
{{- end -}}
