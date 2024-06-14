{{/*
Expand the name of the chart.
*/}}
{{- define "csi-driver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "csi-driver.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
smtx-{{ default .Chart.Name .Values.nameOverride }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "csi-driver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "csi-driver.labels" -}}
helm.sh/chart: {{ include "csi-driver.chart" . }}
{{ include "csi-driver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "csi-driver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "csi-driver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "csi-driver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "csi-driver.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the node plugin common volumes
*/}}
{{- define "csi-driver.node.volumes.common" -}}
- name: iscsi-config
  configMap:
    name: {{ include "csi-driver.fullname" . }}-iscsi-config
    items:
    - key: iscsi
      path: iscsi.yaml
{{- end }}

{{/*
Create the node plugin common volumeMounts
*/}}
{{- define "csi-driver.node.volumeMounts.common" -}}
- name: iscsi-config
  mountPath: /etc/iomesh
  readOnly: true
{{- end }}

{{/*
Create the node plugin volumes
*/}}
{{- define "csi-driver.node.volumes" -}}
volumes:
{{ include "csi-driver.node.volumes.common" . }}
- name: socket-dir
  hostPath:
    path: {{ .Values.driver.node.driver.kubeletRootDir }}/plugins/{{- include "csi-driver.driver.name" .}}
    type: DirectoryOrCreate
- name: pods-mount-dir
  hostPath:
    path: {{ .Values.driver.node.driver.kubeletRootDir }}
    type: Directory
- name: device-dir
  hostPath:
    path: /dev
    type: Directory
- name: registration-dir
  hostPath:
    path: {{ .Values.driver.node.driver.kubeletRootDir }}/plugins_registry/
    type: DirectoryOrCreate
- name: iscsi-dir
  hostPath:
    path: /etc/iscsi
    type: Directory
- name: iscsi-lib
  hostPath:
    path: /var/lib/iscsi
    type: DirectoryOrCreate
- name: iscsiadm
  hostPath:
    path: /sbin/iscsiadm
    type: File
{{- if .Values.driver.nvmf.enable }}
- name: nvme
  hostPath:
    path: /usr/sbin/nvme
    type: File
{{- end }}
- name: lib
  hostPath:
    path: /lib
    type: DirectoryOrCreate
- name: lib64
  hostPath:
    path: /lib64
    type: DirectoryOrCreate
- name: usr-lib64
  hostPath:
    path: /usr/lib64
    type: DirectoryOrCreate
- name: sys
  hostPath:
    path: /sys
    type: Directory
- name: iscsi-run-lock
  hostPath:
    path: /run/lock/iscsi
    type: DirectoryOrCreate
- name: iscsi-var-lock
  hostPath:
    path: /var/lock/iscsi
    type: DirectoryOrCreate
{{- end }}

{{/*
Create the node plugin volumeMounts
*/}}
{{- define "csi-driver.node.volumeMounts" -}}
volumeMounts:
{{ include "csi-driver.node.volumeMounts.common" . }}
- name: socket-dir
  mountPath: /csi
- name: pods-mount-dir
  mountPath: {{ .Values.driver.node.driver.kubeletRootDir }}
  mountPropagation: Bidirectional
- name: device-dir
  mountPath: /dev
- name: iscsi-dir
  mountPath: /host/etc/iscsi
- name: iscsiadm
  mountPath: /host/sbin/iscsiadm
{{- if .Values.driver.nvmf.enable }}
- name: nvme
  mountPath: /host/usr/sbin/nvme
- name: device-dir
  mountPath: /host/dev
{{- end }}
- name: iscsi-lib
  mountPath: /host/var/lib/iscsi
- name: lib
  mountPath: /host/lib
- name: lib64
  mountPath: /host/lib64
- name: usr-lib64
  mountPath: /host/usr/lib64
- name: sys
  mountPath: /host/sys
- name: iscsi-run-lock
  mountPath: /host/run/lock/iscsi
- name: iscsi-var-lock
  mountPath: /host/var/lock/iscsi
{{- end }}

{{/*
csi-driver image
*/}}
{{- define "csi-driver.image" -}}
{{ .Values.global.registry }}{{ .Values.driver.image.repository }}:{{ .Values.driver.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
csi-driver storageClass name
*/}}
{{- define "csi-driver.storageClass.name" -}}
{{- if .Values.storageClass.nameOverride }}
{{- .Values.storageClass.nameOverride }}
{{- else -}}
smtx-{{include "csi-driver.name" .}}
{{- end }}
{{- end }}

{{- define "csi-driver.driver.name" -}}
{{- if .Values.driver.nameOverride }}
{{- .Values.driver.nameOverride }}
{{- else -}}
com.smartx.{{ include "csi-driver.name" . }}
{{- end }}
{{- end }}

{{/*
Prepare-csi image
*/}}
{{- define "prepareCSI.image" -}}
{{ .Values.global.registry }}{{ .Values.prepareCSI.image.repository | default "iomesh/prepare-csi"}}:{{ .Values.prepareCSI.image.tag | default "v1.0.2" }}
{{- end }}
