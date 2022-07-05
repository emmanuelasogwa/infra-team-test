output "lb_endpoint" {
  value = "http://${aws_lb.infra_test.dns_name}"
}

output "application_endpoint" {
  value = "http://${aws_lb.infra_test.dns_name}"
}

output "asg_name" {
  value = aws_autoscaling_group.infra_test.name
}

