data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

# Subnet Group necessário para o RDS no AWS Academy
resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "tc-rds-subnet-group-"
  subnet_ids  = data.aws_subnets.default.ids

  tags = {
    Name = "tc-rds-subnet-group"
  }
}

# Security Group para o MySQL
resource "aws_security_group" "rds_sg" {
  name_prefix = "tc-rds-sg-"
  description = "Security group para o RDS MySQL"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite acesso do cluster K3s na VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instância RDS MySQL
resource "aws_db_instance" "mysql" {
  identifier           = "tc-soat-db"
  allocated_storage    = 20
  max_allocated_storage = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro" # t3.micro obrigatório no Learner Lab
  
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot    = true
  publicly_accessible    = true
  storage_encrypted      = false # Evita rejeição de KMS key no Academy
}