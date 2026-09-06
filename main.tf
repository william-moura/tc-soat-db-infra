terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Subnet Group para o RDS usando subnets privadas da VPC
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "tc-soat-rds-subnet-group"
  subnet_ids = ["subnet-0a1b2c3d4e5f6g7h8", "subnet-0b2c3d4e5f6g7h8i9"] # Substituir pelos IDs das subnets privadas

  tags = {
    Name = "TC-SOAT-RDS-Subnet-Group"
  }
}

# Security Group para o RDS
resource "aws_security_group" "rds_sg" {
  name        = "tc-soat-rds-sg"
  description = "Permite acesso ao RDS a partir do cluster EKS e Lambda"
  vpc_id      = "vpc-0a1b2c3d4e5f6g7h8" # Substituir pelo ID da sua VPC

  ingress {
    from_port   = 5432 # 3306 para MySQL ou 5432 para PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Faixa IP interna da VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tc-soat-rds-sg"
  }
}

# Instância RDS Gerenciada (PostgreSQL)
resource "aws_db_instance" "postgres" {
  identifier             = "tc-soat-db"
  allocated_storage      = 20
  max_allocated_storage  = 50
  engine                 = "postgres" # Altere para "mysql" se preferir MySQL
  engine_version         = "15.4"
  instance_class         = "db.t3.micro" # Compatível com AWS Free Tier / AWS Academy
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Environment = "Production"
    Project     = "TechChallenge-SOAT"
  }
}