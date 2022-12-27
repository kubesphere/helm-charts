{{- define "clickhouse.monitor.container" }}
{{- $clickhouse := .clickhouse }}
{{- $Chart := .Chart }}
- name: clickhouse-monitor
  image: {{ include "clickHouseMonitorImage" . | quote }}
  imagePullPolicy: {{ $clickhouse.monitor.image.pullPolicy }}
  env:
    - name: CLICKHOUSE_USERNAME
      valueFrom:
        secretKeyRef: 
          name: clickhouse-secret
          key: username
    - name: CLICKHOUSE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: clickhouse-secret
          key: password
    - name: DB_URL
      value: "tcp://localhost:9000"
    - name: TABLE_NAME
      value: "default.flows_local"
    - name: MV_NAMES
      value: "default.flows_pod_view_local default.flows_node_view_local default.flows_policy_view_local"
    - name: STORAGE_SIZE
      value: {{ $clickhouse.storage.size | quote }}
    - name: THRESHOLD
      value: {{ $clickhouse.monitor.threshold | quote }}
    - name: DELETE_PERCENTAGE
      value: {{ $clickhouse.monitor.deletePercentage | quote }}
    - name: EXEC_INTERVAL
      value: {{ $clickhouse.monitor.execInterval }}
    - name: SKIP_ROUNDS_NUM
      value: {{ $clickhouse.monitor.skipRoundsNum | quote }}
{{- end }}

{{- define "clickhouse.server.container" }}
{{- $clickhouse := .clickhouse }}
{{- $enablePV := .enablePV }}
{{- $Chart := .Chart }}
- name: clickhouse
  image: {{ include "clickHouseServerImage" . | quote }}
  imagePullPolicy: {{ $clickhouse.image.pullPolicy }}
  volumeMounts:
    - name: clickhouse-configmap-volume
      mountPath: /docker-entrypoint-initdb.d
    {{- if not $enablePV }}
    - name: clickhouse-storage-volume
      mountPath: /var/lib/clickhouse
    {{- end }}
  env:
    - name: THEIA_VERSION
      value: {{ $Chart.Version }}
    - name: CLICKHOUSE_INIT_TIMEOUT
      value: "60"
    - name: DB_URL
      value: "localhost:9000"
    - name: MIGRATE_USERNAME
      valueFrom:
        secretKeyRef: 
          name: clickhouse-secret
          key: username
    - name: MIGRATE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: clickhouse-secret
          key: password
{{- end }}

{{- define "clickhouse.volume" }}
{{- $clickhouse := .clickhouse }}
{{- $enablePV := .enablePV }}
{{- $Files := .Files }}
- name: clickhouse-configmap-volume
  configMap:
    name: clickhouse-mounted-configmap
    items:
      {{- range $path, $_ :=  $Files.Glob  "provisioning/datasources/*.sh" }}
      - key: {{ regexReplaceAll "(.*)/" $path "" }}
        path: {{ regexReplaceAll "(.*)/" $path "" }}
      {{- end }}
      {{- range $path, $_ :=  $Files.Glob  "provisioning/datasources/migrators/downgrade/*" }}
      - key: {{ regexReplaceAll "(.*)/" $path "" }}
        path: migrators/downgrade/{{ regexReplaceAll "(.*)/" $path "" }}
      {{- end }}
      {{- range $path, $_ :=  $Files.Glob  "provisioning/datasources/migrators/*.sql" }}
      - key: {{ regexReplaceAll "(.*)/" $path "" }}
        path: migrators/{{ regexReplaceAll "(.*)/" $path "" }}
      {{- end }}
{{- if not $enablePV }}
- name: clickhouse-storage-volume
  emptyDir:
    medium: Memory
    sizeLimit: {{ $clickhouse.storage.size }}
{{- end }}
{{- end }}


{{- define "theiaImageTag" -}}
{{- $tag := .tag -}}
{{- $Chart := .Chart -}}
{{- if $tag }}
{{- $tag -}}
{{- else if eq $Chart.AppVersion "latest" }}
{{- print "latest" -}}
{{- else }}
{{- print "v" $Chart.AppVersion -}}
{{- end }}
{{- end -}}


{{- define "clickHouseMonitorImage" -}}
{{- print .clickhouse.monitor.image.repository ":" (include "theiaImageTag" (dict "tag" .clickhouse.monitor.image.tag "Chart" .Chart)) -}}
{{- end -}}

{{- define "clickHouseServerImage" -}}
{{- print .clickhouse.image.repository ":" (include "theiaImageTag" (dict "tag" .clickhouse.image.tag "Chart" .Chart)) -}}
{{- end -}}

{{- define "theiaManagerImageTag" -}}
{{- if .Values.theiaManager.image.tag }}
{{- .Values.theiaManager.image.tag -}}
{{- else if eq .Chart.AppVersion "latest" }}
{{- print "latest" -}}
{{- else }}
{{- print "v" .Chart.AppVersion -}}
{{- end }}
{{- end -}}

{{- define "theiaManagerImage" -}}
{{- print .Values.theiaManager.image.repository ":" (include "theiaManagerImageTag" .) -}}
{{- end -}}
