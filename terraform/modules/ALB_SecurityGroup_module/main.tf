# Child Module
resource "aws_security_group" "ALB" {
  name        = "${var.name}-ALB"
  description = "my ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name        = "${var.name}-ALB"
    CreatedBy   = "${var.mail}"
  }
}
