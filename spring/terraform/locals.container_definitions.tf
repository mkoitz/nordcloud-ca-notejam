locals {
  container_definition = {
    essential = true
    name      = local.application
    image     = "${aws_ecr_repository.notejam.repository_url}:${local.docker_tag}"
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }
    ]
    environment = [
      {
        name  = "SPRING_PROFILES_ACTIVE"
        value = terraform.workspace
      },
      {
        name  = "LOG_LEVEL"
        value = terraform.workspace == "production" ? "info" : "debug"
      },
      {
        name  = "APPLICATION_NAME"
        value = local.application
      },
      {
        name  = "DB_URL"
        value = "jdbc:mysql://${aws_rds_cluster.notejam.endpoint}:${aws_rds_cluster.notejam.port}/${aws_rds_cluster.notejam.database_name}"
      },
      {
        name  = "DB_USERNAME"
        value = aws_rds_cluster.notejam.master_username // create application user, SecretsManager
      },
      {
        name  = "DB_PASSWORD"
        value = aws_rds_cluster.notejam.master_password // create application password, use SecretsManager
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.notejam.name
        awslogs-region        = "eu-west-1"
        awslogs-stream-prefix = "ecs"
      }
    }
    cpu = 0
    dockerLabels = {
      version = local.docker_tag
    }
    mountPoints = []
    volumesFrom = []
  }
}
