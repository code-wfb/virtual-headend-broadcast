Markdown

# 📡 AWS Cloud Virtual Headend - Hybrid Transmission Architecture
> **Enterprise-grade Infrastructure as Code (IaC) for Resilient Cloud-native Broadcast Workflows.** > *Infraestrutura como Código de classe corporativa para fluxos de transmissão resilientes e nativos em nuvem.*

---

## 🇺🇸 English Version

### 🎯 Business Case & Overview
Traditional television and broadcast operations historically depend on dense, high-cost on-premises SDI hardware, local physical Master Control Rooms (MCRs), and discrete commercial playout servers at every regional affiliate station. This traditional model features high CapEx, complex physical maintenance, and isolated operations.

This repository hosts a production-ready, highly available **Virtual Headend and Hybrid Network Architecture** built strictly under the **AWS Well-Architected Framework (Reliability and Security pillars)**. It leverages **Terraform** to orchestrate cloud-native live video transport and secure site-to-site connectivity.

#### Key Benefits:
* **75% CapEx Reduction:** Replaces regional physical playout and SDI matrices with cloud-native virtual resources.
* **Operational Consolidation:** Centralizes multiple regional monitoring outputs into a unified cloud interface.
* **Active-Active Redundancy:** Resilient video acquisition pipeline over commercial internet connections.

---

### 🧱 Architectural Highlights & Network Flow
The infrastructure is segmented into specialized modules designed for high availability:

1. **Hybrid Network Module (`vpc_network`):**
   * Creates a dedicated, isolated Transmission VPC.
   * Provisions an **AWS Transit Gateway (TGW)** acting as the central transit hub.
   * Configures redundant **AWS Site-to-Site VPNs** with **ECMP (Equal-Cost Multi-Path)** active-active routing to safely ingest streams from the physical studio across distinct ISPs.
2. **Media Security Module (`media_services`):**
   * Deploys strict stateful firewall rules (Security Groups) permitting only authenticated incoming SRT handshakes on port `5000`.
3. **Transport Pipeline (`media_connect`):**
   * provisions **AWS Elemental MediaConnect** flows inside private subnets using a secure VPC Interface.
   * Configured as an **SRT Listener** to ingest high-bitrate live video feeds (up to 20 Mbps) with low latency.

---

### 🛠️ Tech Stack
* **IaC Tool:** Terraform (v1.5+)
* **Providers:** * `hashicorp/aws` (Standard AWS Resources)
  * `hashicorp/awscc` (AWS Cloud Control API for optimized MediaConnect deployment)
* **Core Services:** AWS Elemental MediaConnect, AWS Transit Gateway, AWS Site-to-Site VPN, AWS VPC, AWS IAM.
* **Transport Protocols:** SRT (Secure Reliable Transport) & IPsec.

---

### 🚀 How to Deploy

#### Prerequisites
1. Installed **Terraform CLI** (v1.5.0 or superior).
2. Configured **AWS CLI** with appropriate administrator credentials (`aws configure`).

#### Commands
```bash
# 1. Clone the repository
git clone [https://github.com/code-wfb/virtual-headend-broadcast.git](https://github.com/code-wfb/virtual-headend-broadcast.git)
cd virtual-headend-broadcast

# 2. Initialize and download providers (AWS and AWSCC)
terraform init

# 3. Generate and review the execution plan
terraform plan

# 4. Provision the infrastructure on AWS
terraform apply

🔒 Security & Best Practices

    Zero Secrets Hardcoded: No static credentials are kept in the codebase. All access relies on IAM instance profiles and local secure CLI environment variables.

    Isolated Data Plane: Live video pipelines are kept entirely within private subnets. No public IP addresses are exposed.

    Enterprise-grade Encryption: Video signals are ingested via IPSec-encrypted tunnels, and the SRT stream uses built-in cryptographic handshakes.

🇧🇷 Versão em Português
🎯 Caso de Negócio & Visão Geral

As operações tradicionais de televisão e transmissão de vídeo dependem historicamente de hardware SDI local denso e caro, Master Control Rooms (MCRs) físicos e servidores de playout comerciais locais em cada geradora ou afiliada regional. Esse modelo tradicional exige alto CapEx, manutenção física complexa e dificulta a escala.

Este repositório contém uma Arquitetura de Rede Híbrida e Virtual Headend altamente disponível e pronta para produção, desenvolvida sob as diretrizes do AWS Well-Architected Framework. O projeto utiliza Terraform para orquestrar transporte de vídeo ao vivo e conectividade híbrida segura.
Principais Benefícios:

    75% de Redução de CapEx: Substituição de servidores e matrizes SDI físicas por recursos virtuais e centralizados em nuvem.

    Consolidação Operacional: Centraliza o monitoramento e gerenciamento de múltiplas afiliadas em um console unificado.

    Redundância Ativa-Ativa: Pipeline de aquisição de vídeo resiliente operando através de conexões de internet comercial redundantes.

🧱 Destaques da Arquitetura e Fluxo de Rede

A infraestrutura está dividida em módulos especializados focados em alta disponibilidade:

    Módulo de Rede Híbrida (vpc_network):

        Cria uma VPC dedicada e isolada para transmissão.

        Provisiona um AWS Transit Gateway (TGW) como hub de roteamento central.

        Estabelece conexões AWS Site-to-Site VPN redundantes com ECMP (Equal-Cost Multi-Path) ativo-ativo para receber os sinais do estúdio físico por provedores de internet (ISPs) distintos.

    Módulo de Segurança (media_services):

        Implementa regras estritas de firewall (Security Groups) que liberam apenas tráfego SRT autenticado na porta de entrada 5000.

    Pipeline de Transporte de Mídia (media_connect):

        Provisiona fluxos do AWS Elemental MediaConnect associados de forma privada à VPC por meio de uma VPC Interface.

        Configurado no modo SRT Listener para recepção estável de feeds de alta taxa de bits (até 20 Mbps) com baixa latência.

🛠️ Tecnologias Utilizadas

    Ferramenta de IaC: Terraform (v1.5+)

    Provedores: * hashicorp/aws (Recursos AWS Padrão)

        hashicorp/awscc (AWS Cloud Control API para otimização do MediaConnect)

    Serviços Core: AWS Elemental MediaConnect, AWS Transit Gateway, AWS Site-to-Site VPN, AWS VPC, AWS IAM.

    Protocolos: SRT (Secure Reliable Transport) & IPsec.

🚀 Como Executar
Pré-requisitos

    Terraform CLI instalado (v1.5.0 ou superior).

    AWS CLI configurado com credenciais locais válidas (aws configure).

Comandos
Bash

# 1. Clone o repositório
git clone [https://github.com/code-wfb/virtual-headend-broadcast.git](https://github.com/code-wfb/virtual-headend-broadcast.git)
cd virtual-headend-broadcast

# 2. Inicialize o diretório e baixe os provedores
terraform init

# 3. Valide o plano de execução
terraform plan

# 4. Aplique e construa a infraestrutura na AWS
terraform apply

🔒 Segurança & Boas Práticas

    Zero Chaves no Código: Nenhuma credencial estática ou senha é armazenada no código. O acesso à AWS utiliza autenticação segura por perfis locais do IAM.

    Isolamento de Rede: Os fluxos de transporte de vídeo rodam exclusivamente dentro de sub-redes privadas. Nenhum IP público direto é exposto para a internet.

    Criptografia Fim-a-Fim: A transmissão do sinal do estúdio local para a AWS é encapsulada em túneis IPSec criptografados, somando-se à criptografia nativa do protocolo SRT.