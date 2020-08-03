{{/*
- If `local` is present (true or false; not nil), use that.
- Otherwise, if `global` is present, use that.
- Otherwise, use `default`.

The `default` function won't handle this case correctly as in Sprig,
false is empty.
*/}}
{{- define "gitlab.boolean.local" -}}
{{- if kindIs "bool" .local -}}
{{-   .local -}}
{{- else if kindIs "bool" .global -}}
{{-   .global -}}
{{- else -}}
{{-   .default -}}
{{- end -}}
{{- end -}}
