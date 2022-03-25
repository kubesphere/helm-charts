{{/*
Return online garbage collection configuration.
*/}}
{{- define "registry.gc.config" -}}
gc:
  disabled: {{ .Values.gc.disabled }}
  {{- if .Values.gc.maxbackoff }}
  maxbackoff: {{ .Values.gc.maxbackoff }}
  {{- end }}
  {{- if .Values.gc.noidlebackoff }}
  noidlebackoff: {{ .Values.gc.noidlebackoff }}
  {{- end }}
  {{- if .Values.gc.transactiontimeout }}
  transactiontimeout: {{ .Values.gc.transactiontimeout }}
  {{- end }}
  {{- if .Values.gc.reviewafter }}
  reviewafter: {{ .Values.gc.reviewafter }}
  {{- end }}
  {{- if .Values.gc.manifests }}
  manifests:
    {{- if .Values.gc.manifests.disabled }}
    disabled: {{ .Values.gc.manifests.disabled }}
    {{- end }}
    {{- if .Values.gc.manifests.interval }}
    interval: {{ .Values.gc.manifests.interval }}
    {{- end }}
  {{- end }}
  {{- if .Values.gc.blobs }}
  blobs:
    {{- if .Values.gc.blobs.disabled }}
    disabled: {{ .Values.gc.blobs.disabled }}
    {{- end }}
    {{- if .Values.gc.blobs.interval }}
    interval: {{ .Values.gc.blobs.interval }}
    {{- end }}
    {{- if .Values.gc.blobs.storagetimeout }}
    storagetimeout: {{ .Values.gc.blobs.storagetimeout }}
    {{- end }}
  {{- end }}
{{- end -}}