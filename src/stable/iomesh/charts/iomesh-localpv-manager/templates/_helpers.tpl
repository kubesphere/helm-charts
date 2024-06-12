{{/*
Expand the name of the chart.
*/}}
{{- define "localpvManager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
service account
*/}}
{{- define "localpvManager.serviceAccountName" -}}
{{- default (include "localpvManager.name" .) .Values.serviceAccount.name }}
{{- end }}

{{/*
volumes
*/}}
{{- define "localpvManager.volumes" -}}
volumes:
- name: registration-dir
  hostPath:
    path: {{ .Values.kubeletRootDir }}/plugins_registry/
    type: DirectoryOrCreate
- name: socket-dir
  hostPath:
    path: {{ .Values.kubeletRootDir }}/plugins/{{- include "localpvManager.csi.name" .}}
    type: DirectoryOrCreate
- name: pods-mount-dir
  hostPath:
    path: {{ .Values.kubeletRootDir }}
    type: Directory
- name: device-dir
  hostPath:
    path: /dev
    type: Directory
- name: host-root
  hostPath:
    path: /
    type: Directory
{{- end }}

{{/*
volumeMounts
*/}}
{{- define "localpvManager.volumeMounts" -}}
volumeMounts:
- name: socket-dir
  mountPath: /csi
- name: pods-mount-dir
  mountPath: {{ .Values.kubeletRootDir }}
  mountPropagation: Bidirectional
- name: device-dir
  mountPath: /dev
- name: host-root
  mountPath: /host
  mountPropagation: HostToContainer
{{- end }}

{{/*
image
*/}}
{{- define "localpvManager.image" -}}
{{ .Values.global.registry }}{{ .Values.localpvManager.image.repository }}:{{ .Values.localpvManager.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
storageClass
*/}}
{{- define "localpvManager.storageClass.name.prefix" -}}
{{- .Values.storageClass.nameOverride | default .Chart.Name }}
{{- end }}

{{- define "localpvManager.csi.name" -}}
{{- if .Values.localpvManager.csi.nameOverride }}
{{- .Values.localpvManager.csi.nameOverride }}
{{- else -}}
com.iomesh.{{ include "localpvManager.name" . }}
{{- end }}
{{- end }}

{{/*
labels
*/}}
{{- define "localpvManager.labels" -}}
app.kubernetes.io/name: {{ include "localpvManager.name" . }}
{{- end }}

