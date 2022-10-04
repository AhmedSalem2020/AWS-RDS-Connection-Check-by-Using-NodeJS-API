output "my_secret" {
  value = aws_secretsmanager_secret.secretmasterDB.arn
}