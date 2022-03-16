{{/*
Return migration configuration.
*/}}
{{- define "registry.migration.config" -}}
migration:
  enabled: {{ .Values.migration.enabled | eq true }}
{{-   if .Values.migration.disablemirrorfs }}
  disablemirrorfs: true
{{-   end }}
{{-   if .Values.migration.rootdirectory }}
  rootdirectory: {{ .Values.migration.rootdirectory }}
{{-   end }}
{{- end -}}