output "lb_address" {
  value = aws_lb.notejam.dns_name
}

output "db_address" {
  value = aws_rds_cluster.notejam.endpoint
}