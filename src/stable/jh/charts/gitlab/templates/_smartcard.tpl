{{/* ######### Smartcard related templates */}}

{{/*
Returns the Smartcard hostname.
If the hostname is set in `global.hosts.smartcard.name`, that will be returned,
otherwise the hostname will be assembed using `smartcard` as the prefix, and the `gitlab.assembleHost` function.
*/}}
{{- define "gitlab.smartcard.hostname" -}}
{{- coalesce .Values.global.appConfig.smartcard.clientCertificateRequiredHost .Values.global.hosts.smartcard.name (include "gitlab.assembleHost"  (dict "name" "smartcard" "context" . )) -}}
{{- end -}}


{{- define "gitlab.appConfig.smartcard.configuration" -}}
smartcard:
{{- with $.Values.global.appConfig.smartcard }}
  enabled: {{ eq true .enabled }}
  ca_file: '/etc/gitlab/rails-secrets/smartcard-ca.crt'
  client_certificate_required_host: {{ template "gitlab.smartcard.hostname" $ }}
  client_certificate_required_port: 443
  san_extensions: {{ eq true .sanExtensions }}
  required_for_git_access: {{ eq true .requiredForGitAccess }}
{{- end -}}
{{- end -}}{{/* "gitlab.appConfig.smartcard.configuration" */}}

