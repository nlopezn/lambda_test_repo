
resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  role = aws_iam_role.codebuild-role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "terraform_plan_codebuild" {
  name          = var.codebuild_project_name_plan
  description   = var.codebuild_project_name_plan
  build_timeout = "20"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = var.codepipeline_bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SRC_DIR"
      value = var.codebuild_src_dir
    }

    environment_variable {
        name  = "TF_VERSION"
        value = var.tf_version
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.org_identifier}-${var.environment}-codebuild-logs"
    }
  }

  source_version = "main"

  source {
    type            = "CODEPIPELINE"
    buildspec       = var.buildspec_plan_yml
    git_clone_depth = 0
  }

  tags = {
    name                = "${var.org_identifier}-${var.environment}-codebuild"
  }
}


resource "aws_codebuild_project" "terraform_apply_codebuild" {
  name          = var.codebuild_project_name_apply
  description   = var.codebuild_project_name_apply
  build_timeout = "20"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = var.codepipeline_bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source_version = "main"

  source {
    type            = "CODEPIPELINE"
    buildspec       = var.buildspec_plan_yml
    git_clone_depth = 0
  }
  
  tags = {
    name                = "${var.org_identifier}-${var.environment}-codebuild"
  }
}
