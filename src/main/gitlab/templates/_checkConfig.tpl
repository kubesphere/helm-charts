{{/*
Template for checking configuration

The messages templated here will be combined into a single `fail` call. This creates a means for the user to receive all messages at one time, instead of a frustrating iterative approach.

- `define` a new template, prefixed `gitlab.checkConfig.`
- Check for known problems in configuration, and directly output messages (see message format below)
- Add a line to `gitlab.checkConfig` to include the new template.

Message format:

**NOTE**: The `if` statement preceding the block should _not_ trim the following newline (`}}` not `-}}`), to ensure formatting during output.

```
chart:
    MESSAGE
```
*/}}
{{/*
Compile all warnings into a single message, and call fail.

Due to gotpl scoping, we can't make use of `range`, so we have to add action lines.
*/}}
{{- define "gitlab.checkConfig" -}}
{{- $messages := list -}}
{{/* add templates here */}}
{{- $messages := append $messages (include "gitlab.checkConfig.gitaly.tls" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.sidekiq.queues.mixed" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.sidekiq.queues.cluster" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.sidekiq.experimentalQueueSelector" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.appConfig.maxRequestDurationSeconds" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.gitaly.extern.repos" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.geo.database" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.geo.secondary.database" .) -}}
{{- $messages := append $messages (include "gitlab.task-runner.replicas" .) -}}
{{- $messages := append $messages (include "gitlab.checkConfig.multipleRedis" .) -}}
{{- /* prepare output */}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- /* print output */}}
{{- if $message -}}
{{-   printf "\nCONFIGURATION CHECKS:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Ensure a certificate is provided when Gitaly is enabled and is instructed to
listen over TLS */}}
{{- define "gitlab.checkConfig.gitaly.tls" -}}
{{- if and (and $.Values.gitlab.gitaly.enabled $.Values.global.gitaly.tls.enabled) (not $.Values.global.gitaly.tls.secretName) }}
gitaly: no tls certificate
    It appears Gitaly is specified to listen over TLS, but no certificate was specified.
{{- end -}}
{{- end -}}
{{/* END gitlab.checkConfig.gitaly.tls */}}

{{/* Check configuration of Sidekiq - don't supply queues and negateQueues */}}
{{- define "gitlab.checkConfig.sidekiq.queues.mixed" -}}
{{- if .Values.gitlab.sidekiq.pods -}}
{{-   range $pod := .Values.gitlab.sidekiq.pods -}}
{{-     if and (hasKey $pod "queues") (hasKey $pod "negateQueues") }}
sidekiq: mixed queues
    It appears you've supplied both `queues` and `negateQueues` for the pod definition of `{{ $pod.name }}`. `negateQueues` is not usable if `queues` is provided. Please use only one.
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.checkConfig.sidekiq.queues.mixed */}}

{{/* Check configuration of Sidekiq - queues must be a string when cluster is enabled */}}
{{- define "gitlab.checkConfig.sidekiq.queues.cluster" -}}
{{- if .Values.gitlab.sidekiq.pods -}}
{{-   range $pod := .Values.gitlab.sidekiq.pods -}}
{{-     if and ($pod.cluster) (hasKey $pod "queues") (ne (kindOf $pod.queues) "string") }}
sidekiq: cluster
    The pod definition `{{ $pod.name }}` has `cluster` enabled, but `queues` is not a string.
{{-     else if and ($pod.cluster) (hasKey $pod "negateQueues") (ne (kindOf $pod.negateQueues) "string") }}
sidekiq: cluster
    The pod definition `{{ $pod.name }}` has `cluster` enabled, but `negateQueues` is not a string.
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.checkConfig.sidekiq.queues.cluster */}}

{{/* Check configuration of Sidekiq - cluster must be enabled for experimentalQueueSelector to be valid */}}
{{- define "gitlab.checkConfig.sidekiq.experimentalQueueSelector" -}}
{{- if .Values.gitlab.sidekiq.pods -}}
{{-   range $pod := .Values.gitlab.sidekiq.pods -}}
{{-     if and ($pod.experimentalQueueSelector) (not $pod.cluster) }}
sidekiq: experimentalQueueSelector
    The pod definition `{{ $pod.name }}` has `experimentalQueueSelector` enabled, but does not have `cluster` enabled. `experimentalQueueSelector` only works when `cluster` is enabled.
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.checkConfig.sidekiq.experimentalQueueSelector */}}

{{/*
Ensure a database is configured when using Geo
listen over TLS */}}
{{- define "gitlab.checkConfig.geo.database" -}}
{{- with $.Values.global -}}
{{- if eq true .geo.enabled -}}
{{-   if not .psql.host }}
geo: no database provided
    It appears Geo was configured but no database was provided. Geo behaviors require external databases. Ensure `global.psql.host` is set.
{{    end -}}
{{-   if not .psql.password.secret }}
geo: no database password provided
    It appears Geo was configured, but no database password was provided. Geo behaviors require external databases. Ensure `global.psql.password.secret` is set.
{{   end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.geo.database */}}

{{/*
Ensure a database is configured when using Geo secondary
listen over TLS */}}
{{- define "gitlab.checkConfig.geo.secondary.database" -}}
{{- with $.Values.global.geo -}}
{{- if include "gitlab.geo.secondary" $ }}
{{-   if not .psql.host }}
geo: no secondary database provided
    It appears Geo was configured with `role: secondary`, but no database was provided. Geo behaviors require external databases. Ensure `global.geo.psql.host` is set.
{{    end -}}
{{-   if not .psql.password.secret }}
geo: no secondary database password provided
    It appears Geo was configured with `role: secondary`, but no database password was provided. Geo behaviors require external databases. Ensure `global.geo.psql.password.secret` is set.
{{    end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.geo.secondary.database */}}

{{/*
Ensure the provided global.appConfig.maxRequestDurationSeconds value is smaller than
unicorn's worker timeout */}}
{{- define "gitlab.checkConfig.appConfig.maxRequestDurationSeconds" -}}
{{- $maxDuration := $.Values.global.appConfig.maxRequestDurationSeconds }}
{{- if $maxDuration }}
{{- $workerTimeout := $.Values.global.unicorn.workerTimeout }}
{{- if not (lt $maxDuration $workerTimeout) }}
gitlab: maxRequestDurationSeconds should be smaller than Unicorn's worker timeout
        The current value of global.appConfig.maxRequestDurationSeconds ({{ $maxDuration }}) is greater than or equal to global.unicorn.workerTimeout ({{ $workerTimeout }}) while it should be a lesser value.
{{- end }}
{{- end }}
{{- end }}
{{/* END gitlab.checkConfig.appConfig.maxRequestDurationSeconds */}}

{{/* Check configuration of Gitaly external repos*/}}
{{- define "gitlab.checkConfig.gitaly.extern.repos" -}}
{{-   if (and (not .Values.global.gitaly.enabled) (not .Values.global.gitaly.external) ) }}
gitaly:
    external Gitaly repos needs to be specified if global.gitaly.enabled is not set
{{-   end -}}
{{- end -}}
{{/* END gitlab.checkConfig.gitaly.extern.repos */}}

{{/*
Ensure that gitlab/task-runner is not configured with `replicas` > 1 if
persistence is enabled.
*/}}
{{- define "gitlab.task-runner.replicas" -}}
{{-   $replicas := index $.Values.gitlab "task-runner" "replicas" | int -}}
{{-   if and (gt $replicas 1) (index $.Values.gitlab "task-runner" "persistence" "enabled") -}}
task-runner: replicas is greater than 1, with persistence enabled.
    It appear that `gitlab/task-runner` has been configured with more than 1 replica, but also with a PersistentVolumeClaim. This is not supported. Please either reduce the replicas to 1, or disable persistence.
{{-   end -}}
{{- end -}}
{{/* END gitlab.task-runner.replicas */}}

{{/*
Ensure that `redis.install: false` if configuring multiple Redis instances
*/}}
{{- define "gitlab.checkConfig.multipleRedis" -}}
{{/* "cache" "sharedState" "queues" "actioncable" */}}
{{- $x := dict "count" 0 -}}
{{- range $redis := list "cache" "sharedState" "queues" "actioncable" -}}
{{-   if hasKey $.Values.global.redis $redis -}}
{{-     $_ := set $x "count" ( add1 $x.count ) -}}
{{-    end -}}
{{- end -}}
{{- if and .Values.redis.install ( lt 0 $x.count ) }}
redis:
  If configuring multiple Redis servers, you can not use the in-chart Redis server. Please see https://docs.gitlab.com/charts/charts/globals#configure-redis-settings
{{- end -}}
{{- end -}}
{{/* END gitlab.checkConfig.multipleRedis */}}
