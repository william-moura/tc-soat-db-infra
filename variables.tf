variable "aws_region" {
  default     = "us-east-1"
  description = "Região AWS"
}

variable "db_name" {
  default     = "techchallenge"
  description = "Nome do banco de dados inicial"
}

variable "db_username" {
  default     = "dbadmin"
  description = "Usuário master do banco"
}

variable "db_password" {
  default     = "SenhaSuperSegura123!"
  sensitive   = true
  description = "Senha master do banco de dados"
}