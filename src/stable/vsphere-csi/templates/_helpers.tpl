{{/*
Return the proper controller image name
*/}}
{{- define "vsphere-csi.controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller resizer image name
*/}}
{{- define "vsphere-csi.controller.resizer.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.resizer.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller attacher image name
*/}}
{{- define "vsphere-csi.controller.attacher.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.attacher.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller livenessProbe image name
*/}}
{{- define "vsphere-csi.controller.livenessprobe.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.livenessprobe.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller syncer image name
*/}}
{{- define "vsphere-csi.controller.syncer.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.syncer.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller provisioner image name
*/}}
{{- define "vsphere-csi.controller.provisioner.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.provisioner.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper controller snapshotter image name
*/}}
{{- define "vsphere-csi.controller.snapshotter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.snapshotter.image "global" .Values.global) }}
{{- end -}}



{{/*
Return the proper node registrar image name
*/}}
{{- define "vsphere-csi.node.registrar.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.node.registrar.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper node image name
*/}}
{{- define "vsphere-csi.node.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.node.image "global" .Values.global) }}
{{- end -}}
{{/*
Return the proper node livenessProbe image name
*/}}
{{- define "vsphere-csi.node.livenessprobe.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.node.livenessprobe.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper webhook image name
*/}}
{{- define "vsphere-csi.webhook.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.webhook.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper snapshot webhook image name
*/}}
{{- define "vsphere-csi.snapshotwebhook.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.snapshotwebhook.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "vsphere-csi.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "vsphere-csi.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.controller.image .Values.node.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "vsphere-csi.controller.serviceAccountName" -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.controller.serviceAccount.name "defaultNameSuffix" "controller" "context" $) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "vsphere-csi.node.serviceAccountName" -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.node.serviceAccount.name "defaultNameSuffix" "node" "context" $) }}
{{- end -}}

{{/*
Create the name of the webhook service account to use
*/}}
{{- define "vsphere-csi.webhook.serviceAccountName" -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.webhook.serviceAccount.name "defaultNameSuffix" "webhook" "context" $) }}
{{- end -}}

{{/*
Create the name of the snapshot webhook service account to use
*/}}
{{- define "vsphere-csi.snapshotwebhook.serviceAccountName" -}}
{{ include "common.secrets.name" (dict "existingSecret" .Values.snapshotwebhook.serviceAccount.name "defaultNameSuffix" "snapshotwebhook" "context" $) }}
{{- end -}}


{{/*
Compile all warnings into a single message.
*/}}
{{- define "vsphere-csi.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "vsphere-csi.validateValues.foo" .) -}}
{{- $messages := append $messages (include "vsphere-csi.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Define Name for controller deployment
*/}}
{{- define "vsphere-csi.controllerName" -}}
{{- if .Values.controller.name -}}
{{ .Values.controller.name }}
{{- else -}}
{{ include "common.names.fullname" }}-controller
{{- end -}}
{{- end -}}

{{/*
Define Name for snapshotter daemonset
*/}}
{{- define "vsphere-csi.snapshotwebhookName" -}}
{{- if .Values.snapshotwebhook.name -}}
{{ .Values.snapshotwebhook.name }}
{{- else -}}
{{ include "common.names.fullname" }}-snapshotter
{{- end -}}
{{- end -}}

{{/*
Define Name for node daemonset
*/}}
{{- define "vsphere-csi.nodeName" -}}
{{- if .Values.node.name -}}
{{ .Values.node.name }}
{{- else -}}
{{ include "common.names.fullname" }}-node
{{- end -}}
{{- end -}}

{{/*
Define Name for windowsnode daemonset
*/}}
{{- define "vsphere-csi.winNodeName" -}}
{{- if .Values.win.name -}}
{{ .Values.win.name }}
{{- else -}}
{{ include "common.names.fullname" }}-node-windows
{{- end -}}
{{- end -}}