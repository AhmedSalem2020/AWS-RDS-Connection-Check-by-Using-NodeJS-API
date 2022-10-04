resource "aws_lb" "ALB" {
  name                              = "${var.name}-ALB"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = var.ALB
  subnets                           = [var.Public_Subnet1, var.Public_Subnet2]
  enable_deletion_protection        = false
  enable_cross_zone_load_balancing  = true
  tags = {
    CreatedBy          = "${var.mail}"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetGroup.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "targetGroup" {
  name     = "${var.name}-TargetGroup"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 3
  }

  depends_on = [
    aws_lb.ALB
  ]

  lifecycle {
    create_before_destroy = true
  }

}
