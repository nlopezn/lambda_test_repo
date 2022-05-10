
# Region
variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "tf_version" {
  type = string
}

# 1. github
variable "github_acc_token" {
  type = string
}

variable "source_provider" {
  type = string
}

variable "authorization_type" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "codebuild_src_dir" {
  type = string
}

variable "codepipeline_bucket" {
  type = string
}

variable "codebuild_project_name_plan" {
  type = string
}
variable "codebuild_project_name_apply" {
  type = string
}

variable "emails_list" {
  type = list
}

# AWS CLI Profile name
variable "profile" {
  type = list
  default = "dev"
}

terraform {
  backend "local" {}
#  backend "s3" {
#    bucket                   = "rave-dev-terraform-states"
#    key                      = "10-code-pipeline/"
#    region                   = var.region
#    profile                  = "dev" # check your profile in .aws creds
#    dynamodb_table           = "terraform_state_locking_table"
#    encrypt                  = true
#  }
}
