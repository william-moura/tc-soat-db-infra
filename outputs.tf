output "db_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "Endpoint de conexão do RDS"
}

output "db_name" {
  value       = aws_db_instance.mysql.db_name
  description = "Nome do Banco de Dados"
}