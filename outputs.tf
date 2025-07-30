output "instance_hostname" {
  description = "Private DNS name of the EC2 instance."
  value       = aws_route53_record.server_dns.*.name
}
