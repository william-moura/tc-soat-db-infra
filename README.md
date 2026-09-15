---

### 2. `tc-soat-db-infra` (Infraestrutura do Banco de Dados RDS MySQL)

Crie ou atualize o arquivo **`README.md`** neste repositório:

```markdown
# 🗄️ Tech Challenge - Infraestrutura de Banco de Dados (AWS RDS MySQL)

Este repositório gerencia o provisionamento do banco de dados relacional **AWS RDS (MySQL 8.0)** utilizado pela aplicação Laravel.

---

## 📋 Características do Provisionamento

* **Engine:** MySQL 8.0
* **Classe da Instância:** `db.t3.micro` (respeitando a cota de vCPUs do AWS Academy)
* **Armazenamento:** 20 GB (General Purpose SSD - `gp2`)
* **Rede & Segurança:** Vinculado às subnets da VPC padrão e Security Group liberando a porta `3306` para o cluster K3s.
* **Compliance AWS Academy:** Desabilitada criptografia KMS customizada e snapshot final ao destruir para compatibilidade com o Learner Lab.

---

## 📁 Estrutura do Repositório

```text
.
├── main.tf                 # Recurso aws_db_instance, Subnet Group e Security Group
├── variables.tf            # Declaração das variáveis (db_name, db_user, db_password)
├── outputs.tf              # Exposição do rds_endpoint para uso pela aplicação
└── .github/workflows/
    └── deploy.yml          # Pipeline CI/CD (Terraform Apply)