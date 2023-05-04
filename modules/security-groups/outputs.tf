output "db_security_group_id" {
  value = aws_security_group.db_security_group.id
}

output "public_security_group_id" {
  value = aws_security_group.public_security_group.id
}