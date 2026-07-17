resource "aws_security_group" "media_processing_sg" {
  name        = "${var.project_name}-media-processing-sg"
  description = "Regras de rede para Ingestao SRT/Zixi e chaves DRM/SCTE-35"
  vpc_id      = var.vpc_id

  # Liberação de Entrada para contribuição via SRT (Portas UDP 5000 a 5010)
  ingress {
    description = "Ingestao SRT redundante"
    from_port   = 5000
    to_port     = 5010
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"] # Apenas tráfego privado on-premises via VPN/DX
  }

  # Porta segura para controle SPEKE API / CPIX (DRM)
  ingress {
    description = "Integracao SPEKE API / CPIX"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Correção: Saída liberada corretamente para a internet pública
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-media-sg" }
}