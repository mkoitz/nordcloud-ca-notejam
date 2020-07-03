resource "aws_lb" "notejam" {
  name               = local.application
  internal           = false
  load_balancer_type = "application"
  subnets            = local.subnet_ids

  enable_deletion_protection = true

  tags = local.tags
}

resource "aws_lb_listener" "notejam" {
  load_balancer_arn = aws_lb.notejam.arn

  // use https 443 and configure cert
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.notejam.arn
  }
}

resource "aws_lb_target_group" "notejam" {
  name        = "ecs-${local.application}-${substr(uuid(), 0, 3)}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  // workaroud to change port
  lifecycle {
    create_before_destroy = true
    ignore_changes = [name]
  }

  health_check {
    path = "/signin"

    healthy_threshold   = 5
    unhealthy_threshold = 4

    port = 8080
  }

  depends_on = [aws_lb.notejam]

  tags = local.tags
}