output "public_security_group_id" {
  value = aws_security_group.public_security_group.id
  # depends_on = [aws_security_group.public_security_group]
}