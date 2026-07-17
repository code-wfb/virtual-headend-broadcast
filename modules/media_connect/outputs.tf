output "flow_a_arn" {
  value       = awscc_mediaconnect_flow.srt_ingest_flow_a.id
  description = "ARN do fluxo de ingestão SRT Pipeline A"
}

output "flow_a_source_ip" {
  # No AWSCC, o atributo que expõe os IPs de ingestão é o "source.ingest_ip" dentro da resposta do recurso
  value       = awscc_mediaconnect_flow.srt_ingest_flow_a.source.ingest_ip
  description = "Endereço IP para o qual o codificador local deve apontar o sinal SRT"
}