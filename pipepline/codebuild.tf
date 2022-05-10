
#data "template_file" "buildspec_plan" {
#  template = "${file("buildspec_plan.yaml")}"
#  vars = {
#    env          = var.env_name,
#    TF_VERSION   = var.tf_version
#  }
#}

#data "template_file" "buildspec_apply" {
#  template = "${file("buildspec_apply.yaml")}"
#  vars = {
#    env          = var.env_name,
#    TF_VERSION   = var.tf_version
#  }
#}

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
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY
}
#
#,
#    {
#      "Effect": "Allow",
#      "Action": "secretsmanager:GetSecretValue",
#      "Resource": "arn:aws:secretsmanager:us-east-1:390854006253:secret:siesa-prd-launch-resources-Ux4eJx"
#    },
#    {
#      "Effect": "Allow",
#      "Action": "kms:Decrypt",
#      "Resource": "arn:aws:kms:us-east-1:390854006253:key/95e62567-312f-483f-8cfd-7808308ae22e"
#    }

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

  }

  environment_variable {
      name  = "CODEBUILD_SRC_DIR"
      value = var.codebuild_src_dir
    }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

#    s3_logs {
#      status   = "ENABLED"
#      location = "${aws_s3_bucket.codepipeline_bucket.id}/build-log"
#    }
  }

  source_version = "main"

  source {
    type            = "GITHUB"
    location        = "https://github.com/nlopezn/lambda_test_repo.git"
    buildspec       = "buildspec_plan.yml"
    git_clone_depth = 1
  }

  tags = {
    name                = "${var.org_identifier}-${var.environment}-codebuild"
  }
}


resource "aws_codebuild_project" "terraform_apply_codebuild" {
  name          = var.codebuild_project_name_apply
  description   = var.codebuild_project_name_apply
  build_timeout = "20"
  service_role  = aws_iam_role.codebuild-role

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

#    s3_logs {
#      status   = "ENABLED"
#      location = "${aws_s3_bucket.codepipeline_bucket.id}/build-log"
#    }
  }

  source_version = "main"

  source {
    type            = "GITHUB"
    location        = "https://github.com/nlopezn/lambda_test_repo.git"
    buildspec       = "buildspec_apply.yml"
    git_clone_depth = 1
  }

#  source {
#    buildspec           = data.template_file.buildspec_apply.rendered
#    git_clone_depth     = 0
#    insecure_ssl        = false
#    report_build_status = false
#    type                = "CODEPIPELINE"
#  }

  tags = {
    name                = "${var.org_identifier}-${var.environment}-codebuild"
  }
}

# Webhook to repository
resource "aws_codebuild_webhook" "webhook_to_repository" {
  project_name = aws_codebuild_project.github-to-lambda.name
  build_type   = "BUILD"
  filter_group {
    filter {
      pattern = "*.tf"
      type    = "FILE_PATH"
    }
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

# Repository Authorization
resource "aws_codebuild_source_credential" "source_auth" {
  auth_type   = var.authorization_type
  server_type = var.source_provider
  token       = var.github_acc_token
}