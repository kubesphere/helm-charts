{{/*
webhook.apiversion is used to take care compatibility with admissionregistration.k8s.io api groups

When using this template, it requires the top-level scope
*/}}
{{- define "webhook.apiVersion" -}}
  {{- $webhookApiVersion := "v1beta1" -}}
  {{- if .Capabilities.APIVersions.Has "admissionregistration.k8s.io/v1" -}}
    {{- $webhookApiVersion = "v1" -}}
  {{- end -}}
  {{- printf "admissionregistration.k8s.io/%s" $webhookApiVersion -}}
{{- end -}}

{{/*
Get the caBundle for clients of the webhooks.
It would use .selfSignedCAKeypair as the place to store the generated CA keypair, it is actually kind of dirty work to prevent generating keypair with multiple times.

When using this template, it requires the top-level scope.

*/}}
{{- define "webhook.caBundleCertPEM" -}}
  {{- if .Values.webhook.caBundlePEM -}}
    {{- trim .Values.webhook.caBundlePEM -}}
  {{- else -}}
    {{- /* Generate ca with CN "juicefs-ca" and 5 years validity duration if not exists in the current scope.*/ -}}
    {{- $caKeypair := .selfSignedCAKeypair | default (genCA "juicefs-ca" 1825) -}}
    {{- $_ := set . "selfSignedCAKeypair" $caKeypair -}}
    {{- $caKeypair.Cert -}}
  {{- end -}}
{{- end -}}

{{/*
webhook.certPEM is the cert of certification used by validating/mutating admission webhook server.
Like generating CA, it would use .webhookTLSKeypair as the place to store the generated keypair, it is actually kind of dirty work to prevent generating keypair with multiple times.

When using this template, it requires the top-level scope
*/}}
{{- define "webhook.certPEM" -}}
  {{- if .Values.webhook.crtPEM -}}
    {{- trim .Values.webhook.crtPEM -}}
  {{- else -}}
    {{- /* webhookName would be the FQDN of in-cluster service juicefs controller.*/ -}}
    {{- $webhookName := printf "%s.%s.svc" (include "juicefs-csi.webhook.svc" .) .Release.Namespace }}
    {{- $webhookCA := required "self-signed CA keypair is requried" .selfSignedCAKeypair -}}
    {{- /* Generate cert keypair for webhook with 5 year validity duration. */ -}}
    {{- $webhookServerTLSKeypair := .webhookTLSKeypair | default (genSignedCert $webhookName nil (list $webhookName) 1825 $webhookCA) }}
    {{- $_ := set . "webhookTLSKeypair" $webhookServerTLSKeypair -}}
    {{- $webhookServerTLSKeypair.Cert -}}
  {{- end -}}
{{- end -}}

{{/*
webhook.keyPEM is the key of certification used by validating/mutating admission webhook server.
Like generating CA, it would use .webhookTLSKeypair as the place to store the generated keypair, it is actually kind of dirty work to prevent generating keypair with multiple times.

When using this template, it requires the top-level scope
*/}}
{{- define "webhook.keyPEM" -}}
  {{- if .Values.webhook.keyPEM -}}
    {{ trim .Values.webhook.keyPEM }}
  {{- else -}}
    {{- /* FIXME: Duplicated codes with named template "webhook.keyPEM" because of no way to nested named template.*/ -}}
    {{- /* webhookName would be the FQDN of in-cluster service juicefs controller.*/ -}}
    {{- $webhookName := printf "%s.%s.svc" (include "juicefs-csi.webhook.svc" .) .Release.Namespace -}}
    {{- $webhookCA := required "self-signed CA keypair is requried" .selfSignedCAKeypair -}}
    {{- /* Generate cert key pair for webhook with 5 year validity duration. */ -}}
    {{- $webhookServerTLSKeypair := .webhookTLSKeypair | default (genSignedCert $webhookName nil (list $webhookName) 1825 $webhookCA) -}}
    {{- $_ := set . "webhookTLSKeypair" $webhookServerTLSKeypair -}}
    {{- $webhookServerTLSKeypair.Key -}}
  {{- end -}}
{{- end -}}
