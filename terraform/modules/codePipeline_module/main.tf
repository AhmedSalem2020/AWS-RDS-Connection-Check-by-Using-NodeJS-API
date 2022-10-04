# Child Module

# GitHub Stage resource
resource "aws_codestarconnections_connection" "example" {
  name          = "my-connection"
  provider_type = "GitHub"
}

# CodeDeploy resources
resource "aws_iam_role" "my_codedeployRole" {
  name                = "my_codedeployRole"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# resource "aws_iam_policy_attachment" "attachment" {
#   name       = "codedeployattach"
#   roles      = [aws_iam_role.codedeployRole.name]
#   policy_arn = aws_iam_policy.codedeployRolePolicy.arn
# }


resource "aws_iam_role_policy" "codedeployRolePolicy" {
  role = aws_iam_role.my_codedeployRole.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.b.arn}",
        "${aws_s3_bucket.b.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_codedeploy_app" "app" {
  name = var.app_name
}

resource "aws_codedeploy_deployment_group" "depGroup" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "HelloWorld_DepGroup"
  service_role_arn      = aws_iam_role.my_codedeployRole.arn


  ec2_tag_set {
    ec2_tag_filter {
      key   = "createdBy"
      type  = "KEY_AND_VALUE"
      value = "ahmed.m.salem2020@outlook.com"
    }
  }
}

# CodePipeline resources
resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags   = {
    CreatedBy = "ahmed.m.salem2020@outlook.com"
  }
}
resource "aws_s3_bucket_acl" "test" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "myCodepipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.b.arn}",
        "${aws_s3_bucket.b.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection",
        "sts:AssumeRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_codepipeline" "codepipeline" {
  name     = "BespinGlobal-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.b.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      run_order        = 1

      configuration = {
        ConnectionArn       = aws_codestarconnections_connection.example.arn
        # FullRepositoryId  = "BespinGlobalMEA/cloud-devops-engineer-hiring---bespinglobal-mea-AhmedSalem2020"
        #BranchName         = "dev"
        FullRepositoryId    = "AhmedSalem2020/bespinglobal"
        BranchName          = "main"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name          = "codeDeploy"
      role_arn      = aws_iam_role.my_codedeployRole.arn
      category      = "Deploy"
      owner         = "AWS"
      provider      = "CodeDeploy"
      version       = "1"
      run_order     = 2
      configuration = {
        ApplicationName     = aws_codedeploy_app.app.id
        DeploymentGroupName = aws_codedeploy_deployment_group.depGroup.id
        AppSpecTemplatePath = "appspec.yml"
      }
    }
  }
}