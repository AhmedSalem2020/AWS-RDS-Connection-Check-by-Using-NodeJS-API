resource "aws_launch_configuration" "template" {
  name_prefix                 = "${var.name}-template"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.keyPair
  associate_public_ip_address = "false"
  security_groups             = var.PrivateWebServerSecurityGroup
  iam_instance_profile        = aws_iam_instance_profile.test.id
  user_data                   = <<-EOF
                                #!/bin/bash
                                yum update -y
                                # amazon-linux-extras install epel -y
                                # yum install stress -y
                                # stress -c 4
                                # Installing codeDeploy Agent
                                yum install ruby -y 
                                yum install wget
                                cd /home/ec2-user
                                wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
                                chmod +x ./install
                                ./install auto
                                service codedeploy-agent start
                                #download node and npm
                                #add npm and node to path
                                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
                                . ~/.nvm/nvm.sh
                                export NVM_DIR="$HOME/.nvm"	
                                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
                                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)
                                nvm install 16.0.0
                                nvm use --delete-prefix v16.0.0
                                npm install pm2 -g
                                EOF

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_iam_instance_profile" "test" {
  name = "ec2-instance-profile"
  role =  aws_iam_role.bespinGlobal-role.id
}

resource "aws_iam_role" "bespinGlobal-role" {
  name                = "bespinGlobal-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess","arn:aws:iam::aws:policy/AWSCodeDeployFullAccess", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy  = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2-Policy" {
  role = aws_iam_role.bespinGlobal-role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "${var.my_secret}"
    }
  ]
}
POLICY
}

resource "aws_autoscaling_group" "ASG" {
  name                 =  "${var.name}-ASG"
  launch_configuration = aws_launch_configuration.template.name
  vpc_zone_identifier  = [var.private_subnet1, var.private_subnet2]
  health_check_type    = var.health_check_type
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
   lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "createdBy"
    value               = "ahmed.m.salem2020@outlook.com"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_attachment" "target" {
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  lb_target_group_arn    = var.target_group
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.name}-CPU-Policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ASG.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_policy" {
  alarm_name          = "${var.name}-Alarm_CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ASG.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.cpu_policy.arn]
}