# Child Module
resource "aws_security_group" "PrivateWebServerSecurityGroup" {
  name        = "${var.name}-PrivateWebServerSecurityGroup"
  description = "my security group"
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port = 0
  #   to_port = 0
  #   protocol = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${var.ALB}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-PrivateWebServerSecurityGroup"
    CreatedBy   = "${var.mail}"
  }
}