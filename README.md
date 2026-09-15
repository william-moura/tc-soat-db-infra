# 🗄️ Tech Challenge - Infraestrutura do Banco de Dados (AWS RDS MySQL)

> 📌 **Nota:** Este repositório é parte integrante do ecossistema **Tech Challenge**. Para conferir a visão geral da aplicação, acesse o repositório principal: [tech-challenge](https://github.com/william-moura/tech-challenge).

Este repositório gerencia o provisionamento automatizado do banco de dados relacional **AWS RDS (MySQL 8.0)** utilizando **Terraform** e **GitHub Actions**, respeitando as diretrizes de compliance do **AWS Academy Learner Lab**.

---

## 📋 Especificações do Banco de Dados

* **Engine:** MySQL 8.0
* **Instance Class:** `db.t3.micro` (Obrigatória para não exceder limites de vCPU da cota do Learner Lab)
* **Storage:** 20 GB General Purpose SSD (`gp2`)
* **Rede:** DB Subnet Group associado às subnets da VPC padrão em `us-east-1`
* **Security Group:** Libera tráfego na porta `3306` para os recursos da VPC e para o cluster K3s

---

## 📁 Estrutura de Arquivos

.
├── main.tf                 # Recurso aws_db_instance, Subnet Group e Security Group do RDS
├── variables.tf            # Declaração das variáveis db_name, db_user e db_password
├── outputs.tf              # Exposição do rds_endpoint para consumo da aplicação
└── .github/workflows/
    └── deploy.yml          # Pipeline CI/CD para execução do Terraform Apply

---

## 🔑 Variáveis & Secrets (GitHub Actions)

Cadastre as seguintes Secrets em **Settings > Secrets and variables > Actions**:

| Secret | Descrição | Exemplo |
| :--- | :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso temporária da AWS | `ASIA...` |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta temporária da AWS | `wJalrXUtn...` |
| `AWS_SESSION_TOKEN` | Token de sessão temporário da AWS | `IQoJb3...` |
| `DB_PASSWORD` | Senha Master do banco MySQL | `TechChallenge2026!` |

---

## 🚀 Integração com o Laravel

A pipeline expõe o output `rds_endpoint`. Esse endereço deve ser configurado como a variável `DB_HOST` no `ConfigMap` da aplicação principal no repositório `tech-challenge`:

```env
DB_CONNECTION=mysql
DB_HOST=<endpoint-rds-sem-a-porta>
DB_PORT=3306
DB_DATABASE=techchallenge
DB_USERNAME=dbadmin
DB_PASSWORD=<conteudo-da-secret-DB_PASSWORD>