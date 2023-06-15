{{/* vim: set filetype=mustache: */}}

{{/* labels for helm resources */}}
{{- define "vsphere.labels" -}}
labels:
  heritage: "{{ .Release.Service }}"
  release: "{{ .Release.Name }}"
  revision: "{{ .Release.Revision }}"
  chart: "{{ .Chart.Name }}"
  chartVersion: "{{ .Chart.Version }}"
{{- end -}}

{{/*
To keep compability we need to set csi-attacher matching on kubernetes versions >= Minor 17
*/}}
{{- define "vsphere-csi-driver.csi-attacher.tag" -}}
{{- if (or (gt (.Capabilities.KubeVersion.Minor | int) 17) (eq (.Capabilities.KubeVersion.Minor | int) 17)) -}}
{{- .Values.attacher.image.tagK8sUpMinor17 -}}
{{- else -}}
{{- .Values.attacher.image.tag -}}
{{- end -}}
{{- end -}}
