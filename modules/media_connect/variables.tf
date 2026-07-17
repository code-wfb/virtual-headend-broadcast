variable "project_name" {
  type        = string
  description = "Nome do projeto para tagueamento e padronização de recursos"
}

variable "environment" {
  type        = string
  description = "Ambiente de implantação (ex: prod, dev)"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde a interface de rede do MediaConnect será criada"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Lista de subredes privadas para o Pipeline A e Pipeline B"
}

variable "media_security_group_id" {
  type        = string
  description = "ID do Security Group de mídia para controlar o acesso às portas SRT"
}