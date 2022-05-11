
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

variable "org_identifier" {
  type = string
}

variable "project_name" {
  type = string
}

variable "creator" {
  type = string
}

# 1. github
variable "source_provider" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "repository_branch_name" {
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

variable "buildspec_plan_yml" {
  type = string
}

variable "buildspec_apply_yml" {
  type = string
}

variable "emails_list" {
  type = list
}

# AWS CLI Profile name
variable "profile" {
  type = string
}

terraform {
  backend "local" {}
#  backend "s3" {
#    bucket                   = "rave-dev-terraform-states"
#    key                      = ""
#    region                   = var.region
#    profile                  = "dev" # check your profile in .aws creds
#    dynamodb_table           = "terraform_state_locking_table"
#    encrypt                  = true
#  }
}

locals {
  base_tags = {
    "environment" = var.environment
    "region"      = var.region
    "project"     = var.project_name
    "creator"     = var.creator
  }
}
