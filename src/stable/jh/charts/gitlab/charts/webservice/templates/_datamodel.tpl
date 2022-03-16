{{/* vim: set filetype=mustache: */}}

{{/*
webservice.datamodel.prepare

!! To be run against $

Walks `deployments` and merges `webservice.datamodel.blank` into each
item, ensuring presence of all keys.
*/}}
{{- define "webservice.datamodel.prepare" -}}
{{- $fullname := include "webservice.fullname" $ -}}
{{- $blank := dict -}}
{{/* make sure we always have at least one */}}
{{- if not $.Values.deployments -}}
{{-   $blank := fromYaml (include "webservice.datamodel.blank" $) -}}
{{-   $_ := set $blank.ingress "path" (coalesce $.Values.ingress.path $.Values.global.ingress.path) -}}
{{-   $_ := set $.Values "deployments" (dict "default" (dict)) -}}
{{-   $_ := set $.Values.deployments "default" $blank -}}
{{- end -}}
{{/* walk all entries, ensure default properties populated */}}
{{- $checks := dict "hasBasePath" false -}}
{{- range $deployment, $values := $.Values.deployments -}}
{{-   $filledValues := fromYaml (include "webservice.datamodel.blank" $) -}}
{{-   $_ := include "gitlab.merge.overwriteEmpty" (dict "dst" $filledValues "src" $values) -}}
{{/* mergeOverwrite does not support overlaying empty values */}}
{{/* -   $_ := mergeOverwrite $filledValues $values - */}}
{{-   $_ := set $filledValues "name" $deployment -}}
{{-   $_ := set $filledValues "fullname" $fullname -}}
{{-   $_ := set $.Values.deployments $deployment $filledValues -}}
{{-   if has ($filledValues.ingress.path | toString ) (list "/" "/*") -}}
{{-     $_ := set $checks "hasBasePath" true -}}
{{-   end -}}
{{- end -}}
{{- if and (not $.Values.ingress.requireBaseBath) (not $checks.hasBasePath) -}}
{{-   fail "FATAL: Webservice: no deployment with ingress.path '/' or '/*' specified." -}}
{{- end -}}
{{- end -}}

{{/*
webservice.datamodel.blank

!! To be run against $

Creates a copy of the data model expected for `deployments` entries,
pulling default values from the appropriate items in `.Values.xyz`.
This is output as YAML, it can be read back in as a dict via `toYaml`.
*/}}
{{- define "webservice.datamodel.blank" -}}
ingress:
  path: # intentionally not setting a value. User must set.
  pathType: Prefix
  annotations:
    {{- .Values.ingress.annotations | toYaml | nindent 4 }}
  proxyConnectTimeout: {{ .Values.ingress.proxyConnectTimeout }}
  proxyReadTimeout: {{ .Values.ingress.proxyReadTimeout }}
  proxyBodySize: {{ .Values.ingress.proxyBodySize | quote }}
common:
  labels: {{ mergeOverwrite (deepCopy .Values.global.common.labels) (deepCopy .Values.common.labels) | toYaml | nindent 4 }}
deployment:
  annotations:
    {{- if .Values.deployment.annotations }}
    {{- toYaml .Values.deployment.annotations | nindent 4 }}
    {{- end }}
  labels:
  {{- .Values.deployment | toYaml | nindent 2 }}
pod:
  labels: # additional labels to .podLabels
  annotations: # inherit from .Values.annotations
    {{- if .Values.annotations }}
    {{ toYaml .Values.annotations | nindent 4 }}
    {{- end }}
service:
  labels: # additional labels to .serviceLabels
  type: {{ .Values.service.type }}
  {{- if .Values.service.loadBalancerIP }}
  loadBalancerIP: {{ .Values.service.loadBalancerIP }}
  {{- end }}
  {{- if .Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
    {{- range .Values.service.loadBalancerSourceRanges }}
    - {{ . | quote }}
    {{- end }}
  {{- end }}
  annotations: # additional annotations to .service.annotations
    {{- if .Values.service.annotations }}
    {{ toYaml .Values.service.annotations | nindent 4 }}
    {{- end }}
hpa:
  minReplicas: {{ .Values.minReplicas }} # defaults to .minReplicas
  maxReplicas: {{ .Values.maxReplicas }} # defaults to .maxReplicas
  {{- .Values.hpa | toYaml | nindent 2 }}
pdb:
  maxUnavailable: {{ .Values.maxUnavailable }} # defaults to .maxUnavailable
resources: # resources for `webservice` container
  {{- .Values.resources | toYaml | nindent 2 }}
sharedTmpDir: {{ .Values.sharedTmpDir | toYaml | nindent 2 }}
sharedUploadDir: {{ .Values.sharedUploadDir | toYaml | nindent 2 }}
workhorse:
  {{- .Values.workhorse | toYaml | nindent 2 }}
extraEnv:
  {{- .Values.extraEnv | toYaml | nindent 2 }}
puma:
  {{- .Values.puma | toYaml | nindent 2 }}
workerProcesses: {{ .Values.workerProcesses | int }}
shutdown:
  {{- .Values.shutdown | toYaml | nindent 2 }}
nodeSelector: # map
  {{- if .Values.nodeSelector }}
  {{- .Values.nodeSelector | toYaml | nindent 2 }}
  {{- end }}
tolerations: # array
  {{- if .Values.tolerations }}
  {{- .Values.tolerations | toYaml | nindent 2 }}
  {{- end }}
sshHostKeys: # map
  {{- .Values.sshHostKeys | toYaml | nindent 2 }}
{{- end -}}

{{/*
gitlab.merge.overwriteEmpty

Call: include "gitlab.merge.overwriteEmpty" (dict "dst" .model "src" .values)
Input: (dict "dst" (&dict) "src" (&dict))

Operate on two dictionary, performing effectively "merge", but always
take the value of src if present, even if empty.

- `dst` should be a complete model map
- `src` should have keys on which to overwrite
- A given Map can be emptied by supplying `item: null`, but will otherwise be merged (inherit).

Intended to be recursion capable, implementing deepMerge WithOverwriteWithEmptyValue.
`mergeOverwrite` uses deepMerge WithOverwrite.

See: https://godoc.org/github.com/imdario/mergo#WithOverwriteWithEmptyValue
*/}}
{{- define "gitlab.merge.overwriteEmpty" -}}
{{/* Get a unique list of all keys in both maps */}}
{{- $cache_keys := keys $.src -}}
{{/* Walk all keys in both maps */}}
{{- range $key := $cache_keys -}}
{{/*  If dst and src both have this key, walk */}}
{{-   if and (hasKey $.dst $key) (hasKey $.src $key) -}}
{{/*    If both values are maps, go deeper */}}
{{-     if and (kindIs "map" (index $.src $key)) (kindIs "map" (index $.dst $key)) -}}
{{-       include "gitlab.merge.overwriteEmpty" (dict "dst" (index $.dst $key) "src" (index $.src $key)) -}}
{{-     else -}}
{{/*      If values are not both maps, overwrite with src's value */}}
{{-       $_ := set $.dst $key (index $.src $key) -}}
{{-     end -}}
{{-   end -}}
{{/*  If dst does not have the key in src, add it to dst */}}
{{-   if not (hasKey $.dst $key) -}}
{{-     $_ := set $.dst $key (index $.src $key) -}}
{{-   end -}}
{{- end -}}
{{- end -}}
