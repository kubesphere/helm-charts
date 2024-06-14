{{- define "csi-driver.sidecar.registry" -}}
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

{{- define "csi-driver.sidecar.container-common" -}}
env:
  - name: ADDRESS
    value: /csi/csi.sock
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
volumeMounts:
  - name: socket-dir
    mountPath: /csi
{{- end }}

{{/*
csi-driver controller sidecar
*/}}
{{- define "csi-driver.controller.sidecar" -}}
{{- $kubeMajorVersion := int .Capabilities.KubeVersion.Major }}
{{- $kubeMinorVersion := int (.Capabilities.KubeVersion.Minor | trimAll "+") -}}

{{- $provisionerVersion := "" }}
{{- $snapshotterVersion := "" }}
{{- $attacherVersion := "" }}
{{- $resizerVersion := "" }}
{{- $livenessProbeVersion := "v2.10.0" -}}

{{- /*
k8s 1.22+
*/}}
{{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 22) }}
{{- if and (not (.Capabilities.APIVersions.Has "snapshot.storage.k8s.io/v1alpha1")) (.Capabilities.APIVersions.Has "snapshot.storage.k8s.io/v1beta1") (not (.Capabilities.APIVersions.Has "snapshot.storage.k8s.io/v1")) }}
{{- $provisionerVersion = "v2.1.2" }}
{{- $snapshotterVersion = "v2.1.1" }}
{{- else }}
{{- $provisionerVersion = "v3.5.0" }}
{{- $snapshotterVersion = "v6.2.2" }}
{{- end }}
{{- $attacherVersion = "v4.3.0" }}
{{- $resizerVersion = "v1.8.0" }}
{{- /*
k8s 1.17~1.21
*/}}
{{- else if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 17) (le $kubeMinorVersion 21) }}
{{- $provisionerVersion = "v1.6.0" }}
{{- $snapshotterVersion = "v2.1.1" }}
{{- $attacherVersion = "v2.2.0" }}
{{- $resizerVersion = "v0.5.0" }}
{{- /*
k8s 1.15~1.16
*/}}
{{- else if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 15) (le $kubeMinorVersion 16) }}
{{- $provisionerVersion = "v1.6.0" }}
{{- $attacherVersion = "v2.2.0" }}
{{- $resizerVersion = "v0.5.0" }}
{{- /*
k8s 1.13~1.14
*/}}
{{- else if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 13) (le $kubeMinorVersion 14) }}
{{- $provisionerVersion = "v1.6.0" }}
{{- $attacherVersion = "v1.1.1" }}
{{- $resizerVersion = "v0.5.0" }}
{{- end }}
{{- /*
csi-provisioner sidecar.
When the k8s version is less than 1.17, there is a bug in leader-election-type=leases, so do not specify leader-election-type, 
let the sidecar use the default election method (configmap or endpoint)
*/}}
- name: csi-provisioner
  image: {{ include "csi-driver.sidecar.registry" . }}/csi-provisioner:{{ $provisionerVersion }}
  args:
    - "--csi-address=$(ADDRESS)"
    {{- /* 
    automatically sets pv/pvc name in the CSI CreateVolumeRequest, 
    https://kubernetes-csi.github.io/docs/external-provisioner.html 
    */}}
    - "--extra-create-metadata"
    {{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 22) }}
    - "--leader-election"
    {{- else }}
    - "--enable-leader-election"
    {{- end }}
    {{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 17) (le $kubeMinorVersion 21)}}
    - "--leader-election-type=leases"
    {{- end }}
    {{- if eq .Values.driver.deploymentMode "HCI" }}
    - "--feature-gates=Topology=true"
    {{- end }}
    - "--v=3"
{{ include "csi-driver.sidecar.container-common" . | indent 2 }}
{{- /*
csi-snapshotter sidecar
k8s support csi-snapshotter sidecar in k8s 1.17+
*/}}
{{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 17) }}
- name: csi-snapshotter
  image: {{ include "csi-driver.sidecar.registry" . }}/csi-snapshotter:{{ $snapshotterVersion }}
  args:
  - "--csi-address=$(ADDRESS)"
  - "--leader-election"
  - "--v=3"
{{ include "csi-driver.sidecar.container-common" . | indent 2 }}
{{- end }}
{{- /*
csi-attacher sidecar.
*/}}
- name: csi-attacher
  image: {{ include "csi-driver.sidecar.registry" . }}/csi-attacher:{{ $attacherVersion }}
  args:
    - "--csi-address=$(ADDRESS)"
    - "--leader-election"
    - "--v=3"
{{ include "csi-driver.sidecar.container-common" . | indent 2 }}
{{- /*
csi-resizer sidecar.
k8s support csi-resizer sidecar in k8s 1.14+
*/}}
{{- if and (eq $kubeMajorVersion 1) (ge $kubeMinorVersion 14) }}
- name: csi-resizer
  image: {{ include "csi-driver.sidecar.registry" . }}/csi-resizer:{{ $resizerVersion }}
  args:
    - "--csi-address=$(ADDRESS)"
    - "--leader-election"
    - "--v=3"
{{ include "csi-driver.sidecar.container-common" . | indent 2 }}
{{- end }}
{{- /*
liveness-probe sidecar
*/}}
- name: liveness-probe
  image: {{ include "csi-driver.sidecar.registry" . }}/livenessprobe:{{ $livenessProbeVersion }}
  args:
    - --csi-address=/csi/csi.sock
    - --health-port={{ $.Values.driver.controller.driver.ports.health }}
  volumeMounts:
    - mountPath: /csi
      name: socket-dir
{{- end }}

{{- define "csi-driver.node.sidecar" }}
{{- /*
driver-registrar sidecar
*/}}
- name: driver-registrar
  securityContext:
    privileged: true
  image: {{ include "csi-driver.sidecar.registry" . }}/csi-node-driver-registrar:v2.8.0
  args:
    - --v=5
    - --csi-address=/csi/csi.sock
    - --kubelet-registration-path={{ .Values.driver.node.driver.kubeletRootDir }}/plugins/{{ include "csi-driver.driver.name" . }}/csi.sock
  lifecycle:
    preStop:
      exec:
       command:
          [  
             "/bin/sh",
             "-c",
              "rm -rf /registration/{{ include "csi-driver.driver.name" . }} /registration/{{ include "csi-driver.driver.name" . }}-reg.sock",
          ]
  volumeMounts:
    - name: socket-dir
      mountPath: /csi
    - name: registration-dir
      mountPath: /registration
{{- /*
liveness-probe sidecar
*/}}
- name: liveness-probe
  image: {{ include "csi-driver.sidecar.registry" . }}/livenessprobe:v2.10.0
  args:
    - --csi-address=/csi/csi.sock
    - --health-port={{ $.Values.driver.node.driver.ports.health }}
  volumeMounts:
    - mountPath: /csi
      name: socket-dir
{{- end }}
