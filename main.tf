terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "awscc" {
  region = var.aws_region
}

# 1. Instanciação do Módulo de Rede Híbrida (VPC + TGW + VPN ECMP)
module "network" {
  source               = "./modules/vpc_network"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.10.0/24", "10.100.20.0/24"]
  customer_gw_ip_isp_a = var.customer_gw_ip_isp_a
  customer_gw_ip_isp_b = var.customer_gw_ip_isp_b
}

# 2. Instanciação do Módulo de Segurança e Mídia (Security Groups)
module "media" {
  source       = "./modules/media_services"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

# 3. Instanciação do Módulo do AWS Elemental MediaConnect para Ingestão SRT
module "media_connect" {
  source                  = "./modules/media_connect"
  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  private_subnet_ids      = module.network.private_subnets
  media_security_group_id = module.media.media_security_group_id

  # Passa ambos os provedores para o módulo
  providers = {
    aws   = aws
    awscc = awscc
  }
}