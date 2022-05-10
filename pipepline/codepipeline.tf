# Pipeline Creation 

# Please adjust the Profile variable according to your AWS CLI configuration
provider "aws" {
  region = var.region
  profile = var.profile
}

resource "aws_codepipeline" "codepipeline" {
  
  name     = "${var.org_identifier}-${var.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.repository_name
        BranchName       = "main"
      }
    }
  }
 
  stage {
    name = "TerraformPlan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_plan"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name_plan
      }
    }
  }

  stage {
    name = "ManualApprove"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.pipeline_approval_sns.arn
        CustomData = "Please Review the Terraform Plan Output from the Previous Step"
      }
    }
  }

  stage {
    name = "TerraformApply"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_apply"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name_apply
      }
    }
  }
 
}

#resource "aws_codecommit_repository" "pipeline" {
#  repository_name = var.repository_name
#  description     = "This repo is used to store code artifacts"
#}

resource "aws_iam_role" "codepipeline_role" {
  name = "rave-codepipeline-role"

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
  name = "rave-codepipeline-policy"
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
        "s3:PutObject"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus",      
        "codecommit:CancelUploadArchive",
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_sns_topic" "pipeline_approval_sns" {
  name = "pipeline-approval-update"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}


# ## EMAILS are not supported via terraform
# resource "aws_sns_topic_subscription" "sns-topic" {
#   count = length(var.emails_list)
#   topic_arn = 
#   protocol  = "email"
#   endpoint  = var.emails_list[count.index]
# }


