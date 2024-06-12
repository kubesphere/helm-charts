{{- define "localpvManager.sidecar.registry" -}}
{{ $.Values.global.registry }}
{{- if $.Values.sidecar }}
{{- if $.Values.sidecar.registry }}
{{- $.Values.sidecar.registry }}
{{- else }}
iomesh
{{- end }}
{{- else }}
iomesh
{{- end }}
{{- end }}

{{/*
sidecars common config
*/}}
{{- define "localpvManager.sidecar.containerCommon" -}}
env:
  - name: ADDRESS
    value: /csi/csi.sock
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
  - name: POD_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.name
  - name: NODE_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: spec.nodeName
volumeMounts:
  - name: socket-dir
    mountPath: /csi
{{- end }}

{{/*
sidecars
*/}}
{{- define "localpvManager.sidecar" -}}
{{- $kubeMajorVersion := int .Capabilities.KubeVersion.Major }}
{{- $kubeMinorVersion := int (.Capabilities.KubeVersion.Minor | trimAll "+") -}}
{{- $provisionerVersion := "" }}
{{- $livenessProbeVersion := "v2.8.0" }}
{{- /*
k8s 1.22+
*/}}
{{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 22) }}
{{- $provisionerVersion = "v3.0.0" }}
{{- /*
k8s 1.13~1.21
*/}}
{{- else if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 13) (le $kubeMinorVersion 21) }}
{{- $provisionerVersion = "v2.2.2" }}
{{- end }}
{{- /*
csi-provisioner sidecar.
*/}}
- name: csi-provisioner
  image: {{ include "localpvManager.sidecar.registry" . }}/csi-provisioner:{{ $provisionerVersion }}
  args:
    - "--csi-address=$(ADDRESS)"
    - "--extra-create-metadata"
    - --feature-gates=Topology=true
    - --extra-create-metadata=true
    - --immediate-topology=false
    - --strict-topology=true
    - "--v=3"
{{ include "localpvManager.sidecar.containerCommon" . | indent 2 }}
{{- /*
liveness-probe sidecar
*/}}
- name: liveness-probe
  image: {{ include "localpvManager.sidecar.registry" . }}/livenessprobe:{{ $livenessProbeVersion }}
  args:
    - --csi-address=/csi/csi.sock
    - --health-port={{ $.Values.localpvManager.ports.health }}
{{ include "localpvManager.sidecar.containerCommon" . | indent 2 }}
{{- /*
driver-registrar sidecar
*/}}
- name: driver-registrar
  securityContext:
    privileged: true
  image: {{ include "localpvManager.sidecar.registry" . }}/csi-node-driver-registrar:v2.5.0
  args:
    - --v=5
    - --csi-address=/csi/csi.sock
    - --kubelet-registration-path={{ .Values.kubeletRootDir }}/plugins/{{ include "localpvManager.csi.name" . }}/csi.sock
  lifecycle:
    preStop:
      exec:
       command:
          [  
             "/bin/sh",
             "-c",
              "rm -rf /registration/{{ include "localpvManager.csi.name" . }}/registration/{{ include "localpvManager.csi.name" . }}-reg.sock",
          ]
{{ include "localpvManager.sidecar.containerCommon" . | indent 2 }}
    - name: registration-dir
      mountPath: /registration
{{- end }}
