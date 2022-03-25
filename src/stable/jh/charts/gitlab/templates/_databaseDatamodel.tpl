{{/* vim: set filetype=mustache: */}}

{{/*
database.datamodel.blank

Called with context of `.Values[.global].psql`.

Returns a deepCopy of context, with some keys removed.

Removed:
  - all .knownDecompositions [main, ci, ...]
*/}}
{{- define "database.datamodel.blank" -}}
{{- $psql := deepCopy . -}}
{{- $_ := unset $psql "knownDecompositions" -}}
{{- range $decomposedDatabase := .knownDecompositions -}}
{{-   $_ := unset $psql $decomposedDatabase -}}
{{- end -}}
{{ $psql | toYaml }}
{{- end -}}

{{/*
database.datamodel.prepare

Result:
  `.Values.local.psql` contains a fully composed datamodel of psql properties
  to be passed as the context to other helpers. Which Schema you are in can
  be found via `.Schema`.

How:
  - mergeOverwrite `main` into `x.psql` (if present), so that `main` is the base of future blank
  - ensure `main` exists in both global and local, if not present.
  - mergeOverwrite `.global.psql` `.global.psql.x`
  - mergeOverwrite `.psql` `.psql.x`
  - build $context dict, with .Release .Values.global.psql .Values.psql 

Example object -
  local:
    psql:
      main:
        Schema: main
        Release: # pointer to $.Release
        Values:
          global:
            psql: # mirrored from .Values.global.psql
          psql:   # mirrored from .Values.psql
      ci:
        Schema: ci
        Release: # pointer to $.Release
        Values:
          global:
            psql: # mirrored from .Values.global.psql
          psql:   # mirrored from .Values.psql
*/}}
{{- define "database.datamodel.prepare" -}}
{{- if not (hasKey (get $.Values "local" | default (dict)) "psql") -}}
{{-   $_ := set $.Values "local" (dict "psql" (dict)) -}}
{{-   $global := mergeOverwrite (deepCopy $.Values.global.psql) (deepCopy (get $.Values.global.psql "main" | default (dict))) -}}
{{-   $globalBlank := fromYaml (include "database.datamodel.blank" $global) -}}
{{-   $_ := set $global "main" (deepCopy (get $.Values.global.psql "main" | default $globalBlank)) -}}
{{-   $local  := mergeOverwrite (deepCopy $.Values.psql) (deepCopy (get $.Values.psql "main") | default (dict)) -}}
{{-   $localBlank := fromYaml (include "database.datamodel.blank" $local) -}}
{{-   $_ := set $local "main" (deepCopy (get $.Values.psql "main" | default $localBlank))  -}}
{{-   range $decomposedDatabase := $global.knownDecompositions -}}
{{-     if or (hasKey $global $decomposedDatabase) (hasKey $local $decomposedDatabase) -}}
{{-       $globalSchema := mergeOverwrite (deepCopy $globalBlank) (get $global $decomposedDatabase | default (dict)) -}}
{{-       $localSchema := mergeOverwrite (deepCopy $localBlank) (get $local $decomposedDatabase | default (dict)) -}}
{{-       $context := dict "Schema" $decomposedDatabase "Release" $.Release "Values" (dict "global" (dict "psql" $globalSchema) "psql" ($localSchema) ) -}}
{{-       $_ := set $.Values.local.psql $decomposedDatabase $context -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- end -}}
