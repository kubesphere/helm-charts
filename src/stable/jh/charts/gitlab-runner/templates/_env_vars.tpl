{{- define "gitlab-runner.runner-env-vars" }}
- name: CI_SERVER_URL
  value: {{ include "gitlab-runner.gitlabUrl" . }}
- name: CLONE_URL
  value: {{ default "" .Values.runners.cloneUrl | quote }}
{{- if .Values.runners.requestConcurrency }}
- name: RUNNER_REQUEST_CONCURRENCY
  value: {{ default 1 .Values.runners.requestConcurrency | quote }}
{{- end }}
- name: RUNNER_EXECUTOR
  value: {{ default "kubernetes" .Values.runners.executor | quote }}
- name: REGISTER_LOCKED
  {{ if or (not (hasKey .Values.runners "locked")) .Values.runners.locked -}}
  value: "true"
  {{- else -}}
  value: "false"
  {{- end }}
- name: RUNNER_TAG_LIST
  value: {{ default "" .Values.runners.tags | quote }}
{{- if .Values.runners.outputLimit }}
- name: RUNNER_OUTPUT_LIMIT
  value: {{ .Values.runners.outputLimit | quote }}
{{- end}}
{{- if eq (default "kubernetes" .Values.runners.executor) "kubernetes" }}
{{- if .Values.runners.image }}
- name: KUBERNETES_IMAGE
  value: {{ .Values.runners.image | quote }}
{{- end }}
{{- if .Values.runners.privileged }}
- name: KUBERNETES_PRIVILEGED
  value: "true"
{{- end }}
{{- if or .Values.runners.namespace (not (regexMatch "\\s*namespace\\s*=" .Values.runners.config)) }}
- name: KUBERNETES_NAMESPACE
  value: {{ default .Release.Namespace .Values.runners.namespace | quote }}
{{- end }}
{{- if .Values.runners.pollTimeout }}
- name: KUBERNETES_POLL_TIMEOUT
  value: {{ .Values.runners.pollTimeout | quote }}
{{- end }}
{{- if .Values.runners.builds.cpuLimit }}
- name: KUBERNETES_CPU_LIMIT
  value: {{ .Values.runners.builds.cpuLimit | quote }}
{{- end }}
{{- if .Values.runners.builds.cpuLimitOverwriteMaxAllowed }}
- name: KUBERNETES_CPU_LIMIT_OVERWRITE_MAX_ALLOWED
  value: {{ .Values.runners.builds.cpuLimitOverwriteMaxAllowed | quote }}
{{- end }}
{{- if .Values.runners.builds.memoryLimit }}
- name: KUBERNETES_MEMORY_LIMIT
  value: {{ .Values.runners.builds.memoryLimit | quote }}
{{- end }}
{{- if .Values.runners.builds.memoryLimitOverwriteMaxAllowed }}
- name: KUBERNETES_MEMORY_LIMIT_OVERWRITE_MAX_ALLOWED
  value: {{ .Values.runners.builds.memoryLimitOverwriteMaxAllowed | quote }}
{{- end }}
{{- if .Values.runners.builds.cpuRequests }}
- name: KUBERNETES_CPU_REQUEST
  value: {{ .Values.runners.builds.cpuRequests | quote }}
{{- end }}
{{- if .Values.runners.builds.cpuRequestsOverwriteMaxAllowed }}
- name: KUBERNETES_CPU_REQUEST_OVERWRITE_MAX_ALLOWED
  value: {{ .Values.runners.builds.cpuRequestsOverwriteMaxAllowed | quote }}
{{- end }}
{{- if .Values.runners.builds.memoryRequests }}
- name: KUBERNETES_MEMORY_REQUEST
  value: {{ .Values.runners.builds.memoryRequests| quote }}
{{- end }}
{{- if .Values.runners.builds.memoryRequestsOverwriteMaxAllowed }}
- name: KUBERNETES_MEMORY_REQUEST_OVERWRITE_MAX_ALLOWED
  value: {{ .Values.runners.builds.memoryRequestsOverwriteMaxAllowed | quote }}
{{- end }}
{{- if .Values.runners.serviceAccountName }}
- name: KUBERNETES_SERVICE_ACCOUNT
  value: {{ .Values.runners.serviceAccountName | quote }}
{{- end }}
{{- if .Values.runners.services.cpuLimit }}
- name: KUBERNETES_SERVICE_CPU_LIMIT
  value: {{ .Values.runners.services.cpuLimit | quote }}
{{- end }}
{{- if .Values.runners.services.memoryLimit }}
- name: KUBERNETES_SERVICE_MEMORY_LIMIT
  value: {{ .Values.runners.services.memoryLimit | quote }}
{{- end }}
{{- if .Values.runners.services.cpuRequests }}
- name: KUBERNETES_SERVICE_CPU_REQUEST
  value: {{ .Values.runners.services.cpuRequests | quote }}
{{- end }}
{{- if .Values.runners.services.memoryRequests }}
- name: KUBERNETES_SERVICE_MEMORY_REQUEST
  value: {{ .Values.runners.services.memoryRequests | quote }}
{{- end }}
{{- if .Values.runners.helpers.cpuLimit }}
- name: KUBERNETES_HELPER_CPU_LIMIT
  value: {{ .Values.runners.helpers.cpuLimit | quote }}
{{- end }}
{{- if .Values.runners.helpers.memoryLimit }}
- name: KUBERNETES_HELPER_MEMORY_LIMIT
  value: {{ .Values.runners.helpers.memoryLimit | quote }}
{{- end }}
{{- if .Values.runners.helpers.cpuRequests }}
- name: KUBERNETES_HELPER_CPU_REQUEST
  value: {{ .Values.runners.helpers.cpuRequests | quote }}
{{- end }}
{{- if .Values.runners.helpers.memoryRequests }}
- name: KUBERNETES_HELPER_MEMORY_REQUEST
  value: {{ .Values.runners.helpers.memoryRequests | quote }}
{{- end }}
{{- if .Values.runners.helpers.image }}
- name: KUBERNETES_HELPER_IMAGE
  value: {{ .Values.runners.helpers.image | quote }}
{{- end }}
{{- if .Values.runners.imagePullPolicy }}
- name: KUBERNETES_PULL_POLICY
  value: {{ .Values.runners.imagePullPolicy | quote }}
{{- end }}
{{- if .Values.runners.pod_security_context }}
{{-   if .Values.runners.pod_security_context.run_as_non_root }}
- name: KUBERNETES_POD_SECURITY_CONTEXT_RUN_AS_NON_ROOT
  value: "true"
{{-   end }}
{{-   if .Values.runners.pod_security_context.run_as_user }}
- name: KUBERNETES_POD_SECURITY_CONTEXT_RUN_AS_USER
  value: {{ .Values.runners.pod_security_context.run_as_user | quote }}
{{-   end }}
{{-   if .Values.runners.pod_security_context.run_as_group }}
- name: KUBERNETES_POD_SECURITY_CONTEXT_RUN_AS_GROUP
  value: {{ .Values.runners.pod_security_context.run_as_group | quote }}
{{-   end }}
{{-   if .Values.runners.pod_security_context.fs_group }}
- name: KUBERNETES_POD_SECURITY_CONTEXT_FS_GROUP
  value: {{ .Values.runners.pod_security_context.fs_group | quote }}
{{-   end }}
{{- end }}
{{- end }}
{{- if .Values.runners.cache -}}
{{ include "gitlab-runner.cache" . }}
{{- end }}
{{- if .Values.envVars -}}
{{ range .Values.envVars }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end }}
{{- end }}
