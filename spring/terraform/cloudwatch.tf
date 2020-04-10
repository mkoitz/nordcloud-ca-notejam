resource "aws_cloudwatch_log_group" "notejam" {
  name              = "/ecs/${local.application}-${terraform.workspace}"
  retention_in_days = 30

  tags = local.tags
}