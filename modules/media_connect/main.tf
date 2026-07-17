# 1. Interface de VPC (Usando o provedor AWSCC)
resource "awscc_mediaconnect_flow_vpc_interface" "ingest_interface_a" {
  name               = "${var.project_name}-vpc-interface-a"
  flow_arn           = awscc_mediaconnect_flow.srt_ingest_flow_a.id
  role_arn           = aws_iam_role.mediaconnect_vpc_role.arn
  subnet_id          = var.private_subnet_ids[0]
  security_group_ids = [var.media_security_group_id]
}

# 2. Fluxo de Ingestão SRT (Corrigido o protocolo para srt-listener)
resource "awscc_mediaconnect_flow" "srt_ingest_flow_a" {
  name = "${var.project_name}-srt-ingest-pipeline-a"

  source = {
    name         = "StudioPrimaryFeeda"
    protocol     = "srt-listener" # Ajustado para minúsculas
    ingress_port = 5000
    max_bitrate  = 20000000
    max_latency  = 1000
    stream_id    = "feed_pipeline_a"
  }
}

# 3. Role do IAM para o MediaConnect (Provedor AWS Clássico)
resource "aws_iam_role" "mediaconnect_vpc_role" {
  name = "${var.project_name}-mediaconnect-vpc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "mediaconnect.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "mediaconnect_vpc_policy" {
  role       = aws_iam_role.mediaconnect_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCOFullAccess"
}