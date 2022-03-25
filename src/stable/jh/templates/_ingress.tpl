{{/*
Adds `ingress.class` annotation based on the API version of Ingress.

It expects a dictionary with two entries:
  - `global` which contains global ingress settings, e.g. .Values.global.ingress
  - `context` which is the parent context (either `.` or `$`)
*/}}
{{- define "ingress.class.annotation" -}}
{{-   if not (eq (default "" .global.class) "none" ) -}}
{{-     $apiVersion := include "gitlab.ingress.apiVersion" . -}}
{{-     $className := include "ingress.class.name" . -}}
{{-       if not (eq $apiVersion "networking.k8s.io/v1") -}}
kubernetes.io/ingress.class: {{ $className }}
{{-       end -}}
{{-   end -}}
{{- end -}}

{{/*
Calculates the IngressClass name.

It expects either:
  - a dictionary with two entries:
    - `global` which contains global ingress settings, e.g. .Values.global.ingress
    - `context` which is the parent context (either `.` or `$`)
  - the parent context ($ from caller)
    - This detected by access to both `.Capabilities` and `.Release`

If the value is not set or is set to nil, then it provides a default.
Otherwise, it will use the given value (even an empty string "").
*/}}
{{- define "ingress.class.name" -}}
{{-   $here := dict }}
{{-   if and (hasKey $ "Release") (hasKey $ "Capabilities") -}}
{{-     $here = dict "global" $.Values.global.ingress "context" $ -}}
{{-   else -}}
{{-     $here = . -}}
{{-   end -}}
{{-   if kindIs "invalid" $here.global.class -}}
{{-     printf "%s-nginx" $here.context.Release.Name -}}
{{-   else -}}
{{-     $here.global.class | quote -}}
{{-   end -}}
{{- end -}}

{{/*
Sets `ingressClassName` based on the API version of Ingress.

It expects a dictionary with two entries:
  - `global` which contains global ingress settings, e.g. .Values.global.ingress
  - `context` which is the parent context (either `.` or `$`)
*/}}
{{- define "ingress.class.field" -}}
{{-   if not (eq (default "" .global.class) "none" ) -}}
{{-     $apiVersion := include "gitlab.ingress.apiVersion" . -}}
{{-     if eq $apiVersion "networking.k8s.io/v1" -}}
ingressClassName: {{ include "ingress.class.name" . }}
{{-     end -}}
{{-   end -}}
{{- end -}}
