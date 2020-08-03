{{/* vim: set filetype=mustache: */}}

{{/*
Return the URL desired by Mail_room

If global.redis.queues is present, use this. If not present, use global.redis
*/}}
{{- define "gitlab.mailroom.redis.url" -}}
{{- if $.Values.global.redis.queues -}}
{{- $_ := set $ "redisConfigName" "queues" }}
{{- end -}}
{{- include "gitlab.redis.url" $ -}}
{{- end -}}

{{- define "gitlab.mailroom.redis.sentinels" -}}
{{- if $.Values.global.redis.queues -}}
{{- $_ := set $ "redisConfigName" "queues" }}
{{- end -}}
{{- $sentinels := include "gitlab.redis.sentinels" . }}
{{- if $sentinels -}}
:{{- $sentinels | replace " port:" " :port:" | replace " host:" " :host:" -}}
{{- end -}}
{{- end -}}
