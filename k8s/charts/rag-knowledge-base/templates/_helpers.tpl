{{/*
Expand the name of the chart.
*/}}
{{- define "rag-knowledge-base.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rag-knowledge-base.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rag-knowledge-base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rag-knowledge-base.labels" -}}
helm.sh/chart: {{ include "rag-knowledge-base.chart" . }}
{{ include "rag-knowledge-base.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rag-knowledge-base.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rag-knowledge-base.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rag-knowledge-base.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rag-knowledge-base.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
API Gateway labels
*/}}
{{- define "rag-knowledge-base.apiGateway.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: api-gateway
{{- end }}

{{- define "rag-knowledge-base.apiGateway.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: api-gateway
{{- end }}

{{/*
Embedding Service labels
*/}}
{{- define "rag-knowledge-base.embeddingService.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: embedding-service
{{- end }}

{{- define "rag-knowledge-base.embeddingService.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: embedding-service
{{- end }}

{{/*
LLM Service labels
*/}}
{{- define "rag-knowledge-base.llmService.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: llm-service
{{- end }}

{{- define "rag-knowledge-base.llmService.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: llm-service
{{- end }}

{{/*
Document Processor labels
*/}}
{{- define "rag-knowledge-base.documentProcessor.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: document-processor
{{- end }}

{{- define "rag-knowledge-base.documentProcessor.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: document-processor
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "rag-knowledge-base.frontend.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{- define "rag-knowledge-base.frontend.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
NGINX labels
*/}}
{{- define "rag-knowledge-base.nginx.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: nginx
{{- end }}

{{- define "rag-knowledge-base.nginx.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: nginx
{{- end }}

{{/*
Ollama labels
*/}}
{{- define "rag-knowledge-base.ollama.labels" -}}
{{ include "rag-knowledge-base.labels" . }}
app.kubernetes.io/component: ollama
{{- end }}

{{- define "rag-knowledge-base.ollama.selectorLabels" -}}
{{ include "rag-knowledge-base.selectorLabels" . }}
app.kubernetes.io/component: ollama
{{- end }}
