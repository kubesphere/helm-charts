{{/*
Template for handling deprecation messages

The messages templated here will be combined into a single `fail` call. This creates a means for the user to receive all messages at one time, in place a frustrating iterative approach.

- `define` a new template, prefixed `gitlab.deprecate.`
- Check for deprecated values / patterns, and directly output messages (see message format below)
- Add a line to `gitlab.deprecations` to include the new template.

Message format:

**NOTE**: The `if` statement preceding the block should _not_ trim the following newline (`}}` not `-}}`), to ensure formatting during output.

```
chart:
    MESSAGE
```
*/}}
{{/*
Compile all deprecations into a single message, and call fail.

Due to gotpl scoping, we can't make use of `range`, so we have to add action lines.
*/}}
{{- define "gitlab.deprecations" -}}
{{- $deprecated := list -}}
{{/* add templates here */}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.rails.appConfig" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.minio" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.registryStorage" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.registryHttpSecret" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.registry.replicas" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.unicorn" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.unicornWorkhorse.image" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.webservice.omniauth" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.webservice.ldap" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.global.appConfig.ldap.password" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.sidekiq.cronJobs" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.local.kubectl" .) -}}

{{- $deprecated := append $deprecated (include "gitlab.deprecate.gitlab.gitaly.enabled" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.initContainerImage" .) -}}
{{- $deprecated := append $deprecated (include "external.deprecate.initContainerImage" .) -}}
{{- $deprecated := append $deprecated (include "external.deprecate.initContainerPullPolicy" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.webservice.workerTimeout" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.redis-ha.enabled" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.redis.enabled" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.webservice.service.name" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.gitlab.webservice.service.configuration" .) -}}
{{- $deprecated := append $deprecated (include "gitlab.deprecate.gitlab.gitaly.serviceName" .) -}}
{{- /* prepare output */}}
{{- $deprecated := without $deprecated "" -}}
{{- $message := join "\n" $deprecated -}}

{{- /* print output */}}
{{- if $message -}}
{{-   printf "\nDEPRECATIONS:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Migration of rails shared lfs/artifacts/uploads blocks to globals */}}
{{- define "gitlab.deprecate.rails.appConfig" -}}
{{- range $chart := list "webservice" "sidekiq" "task-runner" -}}
{{-   if index $.Values.gitlab $chart -}}
{{-     range $i, $block := list "lfs" "artifacts" "uploads" -}}
{{-       if hasKey (index $.Values.gitlab $chart) $block }}
{{-         with $config := index $.Values.gitlab $chart $block -}}
{{-           range $item := list "enabled" "bucket" "proxy_download" -}}
{{-             if hasKey $config $item }}
gitlab.{{ $chart }}:
    `{{ $block }}.{{ $item }}` has been moved to global. Please remove `{{ $block }}.{{ $item }}` from your properties, and set `global.appConfig.{{ $block }}.{{ $item }}`
{{-             end -}}
{{-           end -}}
{{-           if .connection -}}
{{-             if without (keys .connection) "secret" "key" | len | ne 0 }}
gitlab.{{ $chart }}:
    The `{{ $block }}.connection` declarations have been moved into a secret. Please create a secret with these contents, and set `global.appConfig.{{ $block }}.connection.secret`
{{-             end -}}
{{-           end -}}
{{-         end -}}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}

{{/* Deprecation behaviors for global configuration of Minio */}}
{{- define "gitlab.deprecate.minio" -}}
{{- if ( hasKey .Values.minio "enabled" ) }}
minio:
    Chart-local `enabled` property has been moved to global. Please remove `minio.enabled` from your properties, and set `global.minio.enabled` instead.
{{- end -}}
{{- if .Values.registry.minio -}}
{{-   if ( hasKey .Values.registry.minio "enabled" ) }}
registry:
    Chart-local configuration of Minio features has been moved to global. Please remove `registry.minio.enabled` from your properties, and set `global.minio.enabled` instead.
{{-   end -}}
{{- end -}}
{{- if .Values.gitlab.webservice.minio -}}
{{-   if ( hasKey .Values.gitlab.webservice.minio "enabled" ) }}
gitlab.webservice:
    Chart-local configuration of Minio features has been moved to global. Please remove `gitlab.webservice.minio.enabled` from your properties, and set `global.minio.enabled` instead.
{{-   end -}}
{{- end -}}
{{- if .Values.gitlab.sidekiq.minio -}}
{{-   if ( hasKey .Values.gitlab.sidekiq.minio "enabled" ) }}
gitlab.sidekiq:
    Chart-local configuration of Minio features has been moved to global. Please remove `gitlab.sidekiq.minio.enabled` from your properties, and set `global.minio.enabled` instead.
{{-   end -}}
{{- end -}}
{{- if index .Values.gitlab "task-runner" "minio" -}}
{{-   if ( hasKey ( index .Values.gitlab "task-runner" "minio" ) "enabled" ) }}
gitlab.task-runner:
    Chart-local configuration of Minio features has been moved to global. Please remove `gitlab.task-runner.minio.enabled` from your properties, and set `global.minio.enabled` instead.
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END deprecate.minio */}}

{{/* Migration of Registry `storage` dict to a secret */}}
{{- define "gitlab.deprecate.registryStorage" -}}
{{- if .Values.registry.storage -}}
{{-   $keys := without (keys .Values.registry.storage) "secret" "key" "extraKey" -}}
{{-   if len $keys | ne 0 }}
registry:
    The `storage` property has been moved into a secret. Please create a secret with these contents, and set `storage.secret`.
{{-   end -}}
{{- end -}}
{{- end -}}

{{/* Migration of Registry `httpSecret` property to secret */}}
{{- define "gitlab.deprecate.registryHttpSecret" -}}
{{- if .Values.registry.httpSecret -}}
registry:
    The `httpSecret` property has been moved into a secret. Please create a secret with these contents, and set `global.registry.httpSecret.secret` and `global.registry.httpSecret.key`.
{{- end -}}
{{- end -}}

{{/* Migration of Registry `minReplicas` and `maxReplicas` to `hpa.*` */}}
{{- define "gitlab.deprecate.registry.replicas" -}}
{{- if or (hasKey .Values.registry "minReplicas") (hasKey .Values.registry "maxReplicas") -}}
registry:
    The `minReplicas` property has been moved under the hpa object. Please create a configuration with the new path: `registry.hpa.minReplicas`.
    The `maxReplicas` property has been moved under the hpa object. Please create a configuration with the new path: `registry.hpa.maxReplicas`.
{{- end -}}
{{- end -}}
{{/* END deprecate.registry.replicas */}}

{{/* Migration from unicorn subchart to webservice */}}
{{- define "gitlab.deprecate.unicorn" -}}
{{- if hasKey .Values.gitlab "unicorn" -}}
unicorn:
    Unicorn chart was deprecated in favour of Webservice. Please remove `gitlab.unicorn.*` settings from your properties, and set `gitlab.webservice.*` instead.
{{- end -}}
{{- if hasKey .Values.global "unicorn" -}}
unicorn:
    Unicorn chart was deprecated in favour of Webservice. Please remove `global.unicorn.*` settings from your properties, and set `global.webservice.*` instead.
{{- end -}}
{{- if hasKey .Values.gitlab.webservice "memory" -}}
webservice:
    The `gitlab.webservice.memory.*` properties have been moved under the unicorn specific section.
    You can move the configuration to `gitlab.webservice.unicorn.memory.*` when you've set the `gitlab.webservice.webServer` to `unicorn`, or remove the `gitlab.webservice.memory` configuration and instead use `gitlab.webservice.puma.workerMaxMemory` to configure Puma's worker memory limits.
{{- end -}}
{{- end -}}
{{/* END gitlab.deprecate.unicorn */}}

{{/* Migration from `global.enterpriseImages.unicorn.workhorse` to global.enterpriseImages.workhorse` */}}
{{- define "gitlab.deprecate.unicornWorkhorse.image" -}}
{{- if hasKey .Values.global "enterpriseImages" -}}
{{-   if hasKey .Values.global.enterpriseImages "unicorn" -}}
{{-     if hasKey .Values.global.enterpriseImages.unicorn "workhorse" -}}
workhorse:
   The `global.enterpriseImages.unicorn.workhorse.*` properties has been moved from the unicorn specific section. Please create a configuration with the new path: `global.enterpriseImages.workhorse.*`.
{{-     end -}}
{{-   end -}}
{{- end -}}

{{- if hasKey .Values.global "communityImages" -}}
{{-   if hasKey .Values.global.communityImages "unicorn" -}}
{{-     if hasKey .Values.global.communityImages.unicorn "workhorse" -}}
workhorse:
   The `global.communityImages.unicorn.workhorse.*` properties has been moved from the unicorn specific section. Please create a configuration with the new path: `global.communityImages.workhorse.*`.
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.deprecate.unicornWorkhorse.image */}}

{{/* Deprecation behaviors for configuration of Omniauth */}}
{{- define "gitlab.deprecate.webservice.omniauth" -}}
{{- if hasKey .Values.gitlab.webservice "omniauth" -}}
webservice:
    Chart-local configuration of Omniauth has been moved to global. Please remove `webservice.omniauth.*` settings from your properties, and set `global.appConfig.omniauth.*` instead.
{{- end -}}
{{- end -}}
{{/* END deprecate.webservice.omniauth */}}

{{/* Deprecation behaviors for configuration of LDAP */}}
{{- define "gitlab.deprecate.webservice.ldap" -}}
{{- if hasKey .Values.gitlab.webservice "ldap" -}}
webservice:
    Chart-local configuration of LDAP has been moved to global. Please remove `webservice.ldap.*` settings from your properties, and set `global.appConfig.ldap.*` instead.
{{- end -}}
{{- end -}}
{{/* END deprecate.webservice.ldap */}}

{{- define "gitlab.deprecate.global.appConfig.ldap.password" -}}
{{- if .Values.global.appConfig.ldap.servers -}}
{{-   $hasPlaintextPassword := dict -}}
{{-   range $name, $config := .Values.global.appConfig.ldap.servers -}}
{{-     if and (hasKey $config "password") (kindIs "string" $config.password) -}}
{{-       $_ := set $hasPlaintextPassword "true" "true" -}}
{{-     end -}}
{{-   end -}}
{{-   if hasKey $hasPlaintextPassword "true" -}}
global.appConfig.ldap:
     Plain-text configuration of LDAP passwords has been deprecated in favor of secret configuration. Please create a secret containing the password, and set `password.secret` and `password.key`.
{{-   end -}}
{{- end -}}
{{- end -}}{{/* "gitlab.deprecate.global.appConfig.ldap.password" */}}

{{/* Deprecation behaviors for configuration of cron jobs */}}
{{- define "gitlab.deprecate.sidekiq.cronJobs" -}}
{{- if hasKey .Values.gitlab.sidekiq "cron_jobs" -}}
sidekiq:
    Chart-local configuration of cron jobs has been moved to global. Please remove `sidekiq.cron_jobs.*` settings from your properties, and set `global.appConfig.cron_jobs.*` instead.
{{- end -}}
{{- end -}}
{{/* END deprecate.sidekiq.cronJobs */}}

{{/* Deprecation behaviors for configuration of local kubectl images */}}
{{- define "gitlab.deprecate.local.kubectl" -}}
{{- range $chart := list "certmanager-issuer" "shared-secrets" -}}
{{-   if hasKey (index $.Values $chart) "image" -}}
{{ $chart }}:
    Chart-local configuration of kubectl image has been moved to global. Please remove `{{ $chart }}.image.*` settings from your properties, and set `global.kubectl.image.*` instead.
{{-     if and (eq $chart "shared-secrets") (hasKey (index $.Values $chart "image") "pullSecrets") }}
    If you need to set `pullSecrets` of the self-sign image, please use `shared-secrets.selfsign.image.pullSecrets` instead.
{{     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.deprecate.local.kubectl */}}

{{/* Deprecation behaviors for configuration of Gitaly */}}
{{- define "gitlab.deprecate.gitlab.gitaly.enabled" -}}
{{-   if hasKey .Values.gitlab.gitaly "enabled" -}}
gitlab:
    Chart-local configuration of Gitaly features has been moved to global. Please remove `gitlab.gitaly.enabled` from your properties, and set `global.gitaly.enabled` instead.
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.gitaly.enabled */}}

{{/* Deprecation behavious for configuration of initContainer images of gitlab sub-charts */}}
{{- define "gitlab.deprecate.initContainerImage" -}}
{{- range $chart:= list "geo-logcursor" "gitaly" "gitlab-exporter" "gitlab-shell" "mailroom" "migrations" "sidekiq" "task-runner" "webservice" }}
{{-     if hasKey (index $.Values.gitlab $chart) "init" -}}
{{-         with $config := index $.Values.gitlab $chart "init" -}}
{{-             if or (and (hasKey $config "image") (kindIs "string" $config.image)) (hasKey $config "tag") }}
gitlab.{{ $chart }}:
    Configuring image for initContainers using gitlab.{{ $chart }}.init.image and gitlab.{{ $chart }}.init.tag has been deprecated. Please use gitlab.{{ $chart }}.init.image.repository and gitlab.{{ $chart }}.init.image.tag for that.
{{-             end -}}
{{-         end -}}
{{-     end -}}
{{- end -}}
{{- end -}}
{{/* END gitlab.deprecate.initContainerImage */}}

{{/* Deprecation behavious for configuration of initContainer images of external charts */}}
{{- define "external.deprecate.initContainerImage" -}}
{{- range $chart:= list "minio" "registry" "redis" "redis-ha" }}
{{-     if hasKey (index $.Values $chart) "init" -}}
{{-         with $config := index $.Values $chart "init" -}}
{{-             if or (and (hasKey $config "image") (kindIs "string" $config.image)) (hasKey $config "tag") }}
{{ $chart }}:
    Configuring image for initContainers using {{ $chart }}.init.image and {{ $chart }}.init.tag has been deprecated. Please use {{ $chart }}.init.image.repository and {{ $chart }}.init.image.tag for that.
{{-             end -}}
{{-         end -}}
{{-     end -}}
{{- end -}}
{{- end -}}
{{/* END external.deprecate.initContainerImage */}}

{{/* Deprecation behavious for configuration of initContainer image pull policy of external charts */}}
{{- define "external.deprecate.initContainerPullPolicy" -}}
{{- range $chart:= list "minio" "registry" }}
{{-     if hasKey (index $.Values $chart) "init" -}}
{{-         with $config := index $.Values $chart "init" -}}
{{-             if hasKey $config "pullPolicy" }}
{{ $chart }}:
    Configuring pullPolicy for initContainer images using {{ $chart }}.init.pullPolicy has been deprecated. Please use {{ $chart }}.init.image.pullPolicy for that.
{{-             end -}}
{{-         end -}}
{{-     end -}}
{{- end -}}
{{- end -}}
{{/* END external.deprecate.initContainerPullPolicy*/}}

{{/* Deprecation behaviors for configuration of webservice worker timeout*/}}
{{- define "gitlab.deprecate.webservice.workerTimeout" -}}
{{- if hasKey .Values.gitlab.webservice "workerTimeout" -}}
webservice:
    Chart-local configuration of Unicorn's worker timeout has been moved to global. Please remove `webservice.workerTimeout` setting from your properties, and set `global.webservice.workerTimeout` instead.
{{- end -}}
{{- end -}}
{{/* END deprecate.webservice.workerTimeout */}}

{{/* Deprecation behaviors for redis-ha.enabled */}}
{{- define "gitlab.deprecate.redis-ha.enabled" -}}
{{-   if hasKey (index .Values "redis-ha") "enabled" -}}
redis-ha:
    The `redis-ha.enabled` has been deprecated. Redis HA is now implemented by the Redis chart.
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.redis-ha.enabled */}}

{{/* Deprecation behaviors for redis.enabled */}}
{{- define "gitlab.deprecate.redis.enabled" -}}
{{-   if hasKey .Values.redis "enabled" -}}
redis:
    The `redis.enabled` has been deprecated. Please use `redis.install` to install the Redis service.
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.redis.enabled */}}

{{/* Deprecation behaviors for webservice.service.name */}}
{{- define "gitlab.deprecate.webservice.service.name" -}}
{{-   if hasKey .Values.gitlab.webservice.service "name" -}}
webservice:
    Chart-local configuration of Unicorn's service name has been deprecated.
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.redis.enabled */}}

{{- define "gitlab.deprecate.gitlab.webservice.service.configuration" -}}
{{-   range $chart := list "gitaly" "gitlab-shell" -}}
{{-     if index $.Values.gitlab $chart -}}
{{-       if hasKey (index $.Values.gitlab $chart) "webservice" }}
gitlab.{{ $chart }}:
    webservice:
      The configuration of 'gitlab.{{ $chart }}.webservice' has been moved to 'gitlab.{{ $chart }}.workhorse' to better reflect the underlying architecture. Please relocate this property.
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.gitlab.webservice.service.configuration */}}

{{- define "gitlab.deprecate.gitlab.gitaly.serviceName" -}}
{{-   if hasKey $.Values.gitlab.gitaly "serviceName" -}}
gitlab.gitaly.serviceName:
      The configuration of 'gitlab.gitaly.serviceName' has been moved to 'global.gitaly.serviceName' to fix an issue with consistent templating. Please relocate this property.
{{-   end -}}
{{- end -}}
{{/* END gitlab.deprecate.gitlab.gitaly.serviceName */}}
