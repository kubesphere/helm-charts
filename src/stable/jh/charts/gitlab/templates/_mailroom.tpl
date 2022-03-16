{{/* ######### mailroom templates */}}

{{- define "gitlab.appConfig.incomingEmail.mountSecrets" -}}
# mount secrets for incomingEmail
{{- if and $.Values.global.appConfig.incomingEmail.enabled (eq $.Values.global.appConfig.incomingEmail.deliveryMethod "webhook") }}
- secret:
    name: {{ template "gitlab.appConfig.incomingEmail.authToken.secret" . }}
    items:
      - key: {{ template "gitlab.appConfig.incomingEmail.authToken.key" . }}
        path: mailroom/incoming_email_webhook_secret
{{- end }}
{{- end -}}{{/* "gitlab.appConfig.incomingEmail.mountSecrets" "*/}}

{{- define "gitlab.appConfig.serviceDeskEmail.mountSecrets" -}}
# mount secrets for serviceDeskEmail
{{- if and $.Values.global.appConfig.serviceDeskEmail.enabled (eq $.Values.global.appConfig.serviceDeskEmail.deliveryMethod "webhook") }}
- secret:
    name: {{ template "gitlab.appConfig.serviceDeskEmail.authToken.secret" . }}
    items:
      - key: {{ template "gitlab.appConfig.serviceDeskEmail.authToken.key" }}
        path: mailroom/service_desk_email_webhook_secret
{{- end }}
{{- end -}}{{/* "gitlab.appConfig.serviceDeskEmail.mountSecrets" "*/}}

{{/*
Return the gitlab-mailroom webhook secrets
*/}}

{{- define "gitlab.appConfig.incomingEmail.authToken.secret" -}}
{{- default (printf "%s-incoming-email-auth-token" .Release.Name) $.Values.global.appConfig.incomingEmail.authToken.secret | quote -}}
{{- end -}}

{{- define "gitlab.appConfig.incomingEmail.authToken.key" -}}
{{- default "authToken" $.Values.global.appConfig.incomingEmail.authToken.key | quote -}}
{{- end -}}

{{- define "gitlab.appConfig.serviceDeskEmail.authToken.secret" -}}
{{- default (printf "%s-service-desk-email-auth-token" .Release.Name) $.Values.global.appConfig.serviceDeskEmail.authToken.secret | quote -}}
{{- end -}}

{{- define "gitlab.appConfig.serviceDeskEmail.authToken.key" -}}
{{- default "authToken" $.Values.global.appConfig.serviceDeskEmail.authToken.key | quote -}}
{{- end -}}
