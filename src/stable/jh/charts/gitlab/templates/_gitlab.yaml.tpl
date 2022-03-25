{{- define "gitlab.appConfig.gitaly" -}}
gitaly:
  client_path: /home/git/gitaly/bin
  token: <%= File.read('/etc/gitlab/gitaly/gitaly_token').strip.to_json %>
{{- end -}}

{{- define "gitlab.appConfig.repositories" -}}
repositories:
  storages: # You must have at least a `default` storage path.
    {{- if .Values.global.praefect.enabled }}
    {{-   include "gitlab.praefect.storages" . | nindent 4 }}
    {{- end }}
    {{- include "gitlab.gitaly.storages" . | nindent 4 }}
{{- end -}}


{{- define "gitlab.appConfig.incoming_email" -}}
incoming_email:
  enabled: {{ eq .incomingEmail.enabled true }}
  address: {{ .incomingEmail.address | quote }}
  {{- if eq .incomingEmail.deliveryMethod "webhook" }}
  secret_file: /etc/gitlab/mailroom/incoming_email_webhook_secret
  {{- end }}
{{- end -}}

{{- define "gitlab.appConfig.service_desk_email" -}}
service_desk_email:
  enabled: {{ eq .serviceDeskEmail.enabled true }}
  address: {{ .serviceDeskEmail.address | quote }}
  {{- if eq .serviceDeskEmail.deliveryMethod "webhook" }}
  secret_file: /etc/gitlab/mailroom/service_desk_email_webhook_secret
  {{- end }}
{{- end -}}

{{- define "gitlab.appConfig.kas" -}}
{{- if (or .Values.global.kas.enabled .Values.global.appConfig.gitlab_kas.enabled) -}}
gitlab_kas:
  enabled: true
  secret_file: /etc/gitlab/kas/.gitlab_kas_secret
  external_url: {{ include "gitlab.appConfig.kas.externalUrl" . | quote }}
  internal_url: {{ include "gitlab.appConfig.kas.internalUrl" . | quote }}
{{- end -}}
{{- end -}}

{{- define "gitlab.appConfig.shell" -}}
gitlab_shell:
  path: /home/git/gitlab-shell/
  hooks_path: /home/git/gitlab-shell/hooks/
  upload_pack: true
  receive_pack: true
{{- end -}}

{{- define "gitlab.appConfig.shell.ssh_port" -}}
ssh_port: {{ include "gitlab.shell.port" . | int }}
{{- end -}}

{{- define "gitlab.appConfig.shell.secret_file" -}}
secret_file: /etc/gitlab/shell/.gitlab_shell_secret
{{- end -}}

{{- define "gitlab.appConfig.extra" -}}
extra:
  {{ if .extra.googleAnalyticsId }}
  google_analytics_id: {{ .extra.googleAnalyticsId | quote }}
  {{- end }}
  {{ if .extra.matomoUrl }}
  matomo_url: {{ .extra.matomoUrl | quote }}
  {{- end }}
  {{ if .extra.matomoSiteId }}
  matomo_site_id: {{ .extra.matomoSiteId | quote }}
  {{- end }}
  {{- if .extra.matomoDisableCookies }}
  matomo_disable_cookies: {{ eq true .extra.matomoDisableCookies }}
  {{- end }}
  {{ if .extra.oneTrustId }}
  one_trust_id: {{ .extra.oneTrustId | quote }}
  {{- end }}
  {{ if .extra.googleTagManagerNonceId }}
  google_tag_manager_nonce_id: {{ .extra.googleTagManagerNonceId | quote }}
  {{- end }}
{{- end -}}

{{- define "gitlab.appConfig.rackAttack" -}}
rack_attack:
  git_basic_auth:
    {{- if .Values.rack_attack.git_basic_auth.enabled }}
    {{- toYaml .Values.rack_attack.git_basic_auth | nindent 4 }}
    {{- end }}
{{- end -}}

{{- define "gitlab.appConfig.cronJobs" -}}
{{- if .cron_jobs }}
cron_jobs:
  {{- toYaml .cron_jobs | nindent 2 }}
{{- end }}
{{- end }}

{{- define "gitlab.appConfig.maxRequestDurationSeconds" -}}
{{/*
    Unless explicitly provided, we need to set maxRequestDurationSeconds to 95% of the
    workerTimeout value specified for webservice (and use its ceiling value).
    However, sprig's `mul` function does not work with floats, so a
    multiplication with `0.95` is not possible. To workaround this, we do the
    following
    1. Scale up the value to the order of 10000 by multiplying it
    with (95 * 100).
    2. Divide the scaled up value by 10000, and the result will be an integer.
    3. If a reminder was present during the division (this is checked using
       modular division), we increment the result by 1. This does the function
       of `ceil` in Ruby.
    4. For example, if webservice's timeout is the default value of 60, the result
       we need is 57. The various values in this workaround will be
       (i)   $workerTimeout = 60
       (ii)  $scaledResult = 570000
       (iii) $reminder = 0
       (iv)  $result = 57
    5. Another example, if webservice's timeout is 61, the result we need is
       58 (ceiling of 0.95 * 61 = 57.95). The various values in this workaround
       will be
       (i)   $workerTimeout = 61
       (ii)  $scaledResult = 579500
       (iii) $reminder = 9500
       (iv)  $result = 57
       (v)   $result = 58 (because there was a remainder, result got incremented)
*/}}
{{- $workerTimeout := $.Values.global.webservice.workerTimeout }}
{{- $scaledResult := mul $workerTimeout 100 95 }}
{{- $remainder := mod $scaledResult 10000 }}
{{- $doCeil := gt $remainder 0 }}
{{- $result := div $scaledResult 10000 }}
{{- if $doCeil }}
{{-   $result = add1 $result }}
{{- end }}
{{- $result }}
{{- end }}
{{/* END gitlab.appConfig.maxRequestDurationSeconds */}}
