{{/* ######### Redis related templates for Rails consumption */}}

{{/*
Render a Redis `resque` format configuration for Rails.
Input: dict "context" $ "name" string
*/}}
{{- define "gitlab.rails.redis.yaml" -}}
{{ .name }}.yml.erb: |
  production:
    url: {{ template "gitlab.redis.url" .context }}
    {{- include "gitlab.redis.sentinels" .context | nindent 4 }}
    id:
    {{- if eq .name "cable" }}
    adapter: redis
    {{-   if index .context.Values.global.redis "actioncable" }}
    channel_prefix: {{ .context.Values.global.redis.actioncable.channelPrefix }}
    {{-   end }}
    {{- end }}
{{- $_ := set .context "redisConfigName" "" }}
{{- end -}}

{{- define "gitlab.rails.redis.resque" -}}
{{- $_ := set $ "redisConfigName" "" }}
{{- include "gitlab.rails.redis.yaml" (dict "context" $ "name" "resque") -}}
{{- end -}}

{{- define "gitlab.rails.redis.cache" -}}
{{- if .Values.global.redis.cache -}}
{{- $_ := set $ "redisConfigName" "cache" }}
{{- include "gitlab.rails.redis.yaml" (dict "context" $ "name" "redis.cache") -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.rails.redis.sharedState" -}}
{{- if .Values.global.redis.sharedState -}}
{{- $_ := set $ "redisConfigName" "sharedState" }}
{{- include "gitlab.rails.redis.yaml" (dict "context" $ "name" "redis.shared_state") -}}
{{- end -}}
{{- end -}}

{{- define "gitlab.rails.redis.queues" -}}
{{- if .Values.global.redis.queues -}}
{{- $_ := set $ "redisConfigName" "queues" }}
{{- include "gitlab.rails.redis.yaml" (dict "context" $ "name" "redis.queues") -}}
{{- end -}}
{{- end -}}

{{/*
cable.yml configuration
If no `global.redis.actioncable`, use `global.redis`
*/}}
{{- define "gitlab.rails.redis.cable" -}}
{{- if .Values.global.redis.actioncable -}}
{{-   $_ := set $ "redisConfigName" "actioncable" }}
{{- end -}}
{{- include "gitlab.rails.redis.yaml" (dict "context" $ "name" "cable") -}}
{{- end -}}
