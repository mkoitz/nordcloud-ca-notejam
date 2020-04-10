resource "aws_ecs_cluster" "notejam" {
  name = local.application
}

resource "aws_ecs_service" "notejam" {
  name = local.application

  cluster = aws_ecs_cluster.notejam.arn

  task_definition                    = "${aws_ecs_task_definition.notejam.family}:${aws_ecs_task_definition.notejam.revision}"
  desired_count                      = terraform.workspace == "production" ? 1 : 1 // use 2 ore more instances in prodiction
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 5
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.notejam.arn
    container_name   = local.application
    container_port   = 8080
  }

  network_configuration {
    assign_public_ip = false

    // use custome security group that only allows port 8080
    security_groups = [
      aws_default_security_group.default.id
    ]

    subnets = local.subnet_ids
  }
}

resource "aws_ecs_task_definition" "notejam" {
  family                   = "${local.application}-${terraform.workspace}"
  container_definitions    = jsonencode([local.container_definition])
  requires_compatibilities = ["FARGATE"]
  cpu    = 256
  memory = 512

  task_role_arn      = aws_iam_role.task.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "awsvpc"
}