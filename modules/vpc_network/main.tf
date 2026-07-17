# VPC Principal de Ingestão e Processamento
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc-${var.environment}"
    Environment = var.environment
  }
}

# Subredes Públicas (OTT Egress / NAT)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Subredes Privadas (Pipeline A e B)
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-pipeline-${count.index == 0 ? "A" : "B"}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

# Transit Gateway com suporte a ECMP Ativo
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "TGW central para conexao de rede hibrida de broadcast"
  amazon_side_asn                 = 64512
  vpn_ecmp_support                = "enable" # Ativa roteamento Multipath ativo-ativo
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = { Name = "${var.project_name}-tgw" }
}

# Associação VPC-TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  tags = { Name = "${var.project_name}-tgw-vpc-attachment" }
}

# TABELA DE ROTAS PRIVADA (Encaminha tráfego on-premises via TGW)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Toda requisição destinada à rede local física (ex: 10.0.0.0/8) vai para o Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Associação das Subredes Privadas com a Route Table Privada
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Gateways de Cliente (Estúdios Físicos)
resource "aws_customer_gateway" "cgw_a" {
  bgp_asn    = 65001
  ip_address = var.customer_gw_ip_isp_a
  type       = "ipsec.1"
  tags       = { Name = "${var.project_name}-cgw-isp-a" }
}

resource "aws_customer_gateway" "cgw_b" {
  bgp_asn    = 65001
  ip_address = var.customer_gw_ip_isp_b
  type       = "ipsec.1"
  tags       = { Name = "${var.project_name}-cgw-isp-b" }
}

# VPNs IPsec dinâmicas com suporte a BGP e ECMP ativo
resource "aws_vpn_connection" "vpn_a" {
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  customer_gateway_id = aws_customer_gateway.cgw_a.id
  type                = "ipsec.1"
  static_routes_only  = false
  tags                = { Name = "${var.project_name}-vpn-link-a" }
}

resource "aws_vpn_connection" "vpn_b" {
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  customer_gateway_id = aws_customer_gateway.cgw_b.id
  type                = "ipsec.1"
  static_routes_only  = false
  tags                = { Name = "${var.project_name}-vpn-link-b" }
}

# Preparação da estrutura para Direct Connect Gateway (Padrão Ouro de Fibra Dedicada)
resource "aws_dx_gateway" "dx_gw" {
  name            = "${var.project_name}-dx-gateway"
  amazon_side_asn = "64513"
}

resource "aws_dx_gateway_association" "dx_tgw" {
  dx_gateway_id         = aws_dx_gateway.dx_gw.id
  associated_gateway_id = aws_ec2_transit_gateway.tgw.id
  allowed_prefixes      = [var.vpc_cidr]
}