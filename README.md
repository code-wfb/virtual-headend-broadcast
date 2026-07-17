Markdown# 📡 AWS Cloud Virtual Headend - Hybrid Transmission Architecture
> *Arquitetura de Transmissão Híbrida e Resiliente em Nuvem*

| 🇺🇸 English Version | 🇧🇷 Versão em Português |
| :--- | :--- |
| This repository contains the Infrastructure as Code (IaC) in **Terraform** structured under the **AWS Well-Architected Framework** guidelines to virtualize a Master Control Room (MCR) and a regional television broadcast network. | Este repositório contém a infraestrutura como código (IaC) em **Terraform** estruturada sob as diretrizes do **AWS Well-Architected Framework** para virtualizar o Master Control Room (MCR) e o Headend de uma rede de transmissão de TV. |

---

## 🗺️ System Architecture / *Arquitetura do Sistema*

```mermaid
graph TD
    %% Estilos Gerais
    classDef aws style fill:#FF9900,stroke:#333,stroke-width:2px,color:#fff;
    classDef onprem style fill:#3F51B5,stroke:#333,stroke-width:2px,color:#fff;
    classDef box style fill:#ECEFF1,stroke:#37474F,stroke-width:1px,color:#333;

    subgraph On_Premises [On-Premises / Physical Studio]
        Encoder[SRT Encoder / Playout] -->|SRT Stream| CGW_A[Customer Gateway - ISP A]
        Encoder -->|SRT Stream| CGW_B[Customer Gateway - ISP B]
    end

    subgraph AWS_Cloud [AWS Cloud]
        TGW[AWS Transit Gateway]:::aws
        CGW_A -->|VPN Tunnel 1 - ECMP| TGW
        CGW_B -->|VPN Tunnel 2 - ECMP| TGW

        subgraph VPC [Transmission VPC - 10.100.0.0/16]
            direction TB
            TGW -->|VPC Attachment| Private_Subnets

            subgraph Public_Subnets [Public Subnets]
                Pub_A[Subnet 1A - 10.100.1.0/24]
                Pub_B[Subnet 1B - 10.100.2.0/24]
            end

            subgraph Private_Subnets [Private Subnets]
                Priv_A[Subnet 2A - 10.100.10.0/24]
                Priv_B[Subnet 2B - 10.100.20.0/24]
                
                subgraph Media_Connect [AWS Elemental MediaConnect]
                    EMX_Interface[VPC Interface]:::aws
                    EMX_Flow[MediaConnect Flow <br> srt-listener :5000]:::aws
                    EMX_Interface --> EMX_Flow
                end
            end
            
            SG[Media Security Group] -.->|Allows Port 5000| EMX_Flow
        end
    end

    %% Conexão interna final
    TGW -->|Internal Routing| EMX_Interface

    %% Aplicação de classes
    class Encoder,CGW_A,CGW_B onprem;
    class VPC,Public_Subnets,Private_Subnets box;
🎯 Business Case & Objectives / Objetivos de Negócio🇺🇸 English🇧🇷 PortuguêsTraditional broadcast operations rely on heavy, expensive on-premises SDI hardware, local commercial playout servers, and graphics insertion per affiliate station.This architecture unifies multiple physical MCRs into a single AWS-hosted Virtual Headend, delivering up to 75% CapEx reduction and centralizing monitoring operations into a single web console.A operação de redes de TV tradicionais depende de hardware local SDI denso e caro em cada mercado regional, servidores de playout comerciais locais e inserção de gráficos por afiliada.Esta arquitetura centraliza múltiplos MCRs físicos em um único Virtual Headend unificado na AWS, obtendo até 75% de redução de CapEx e unificando o monitoramento.🛠️ Tech Stack / Tecnologias UtilizadasTerraform (v1.5+): Declarative multi-provider Infrastructure as Code.AWS & AWSCC Providers: Native Cloud Control API integration for bleeding-edge resources.AWS Elemental MediaConnect: High-quality video transport using SRT (Secure Reliable Transport) protocol.AWS Transit Gateway: Central hub routing IPsec VPN traffic with ECMP (Equal-Cost Multi-Path) active-active load balancing.🚀 How to Deploy / Como ExecutarPrerequisites / Pré-requisitosAWS CLI configured (aws configure)Terraform installed (v1.5.0+)Bash# 1. Clone the repo / Clone o repositório
git clone [https://github.com/your-username/virtual-headend-broadcast.git](https://github.com/your-username/virtual-headend-broadcast.git)
cd virtual-headend-broadcast

# 2. Initialize working directory / Inicialize o diretório
terraform init

# 3. Plan deployment / Verifique o plano
terraform plan

# 4. Apply infrastructure / Aplique a infraestrutura
terraform apply
🔒 Security by Design / Segurança Aplicada🇺🇸 English🇧🇷 Português- Zero Hardcoded Secrets: All AWS credentials leverage IAM local profiles.- Private Networking: MediaConnect flows run inside private subnets.- Encrypted VPN: Redundant IPSec tunnels secure physical studio connectivity.- Zero Secrets Hardcoded: Credenciais AWS usam perfis locais via CLI.- Rede Privada: Fluxos do MediaConnect rodam protegidos dentro de subnets privadas.- VPN Criptografada: Túneis IPSec redundantes garantem tráfego seguro do estúdio físico.