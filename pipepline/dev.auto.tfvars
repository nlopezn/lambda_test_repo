# ******************************************************************************************************************
# *  dev.auto.tfvars                                                                                               *
# ******************************************************************************************************************
# *                                                                                                                *
# *  Project: GovCloud Data Lake MVP.                                                                              *
# *                                                                                                                *
# *  Copyright © 2022 Rave Moblity Safety. All Rights Reserved.                                                    *
# *                                                                                                                *
# *  Author: Nicolas Lopez, Onica ProServe Division, Rackspace Technology, Inc.                            *
# *  Created On: March-10-2022                                                                                     *
# ******************************************************************************************************************


# 0. organization identifier, project, creator environmental, region, and tagging variables
org_identifier                                              = "rave"
project_name                                                = "rave-data-lake"
region                                                      = "us-east-1"
creator                                                     = "Terraform"
environment                                                 = "dev"
profile                                                     = "dev"

codepipeline_bucket                                         = "rave-dev-pipeline-artifacts"
repository_name                                             = "rave-terraform-dev"
tf_version                                                  = "4.3.0"
codebuild_project_name_plan                                 = "terraform-plan-codebuild"
codebuild_project_name_apply                                = "terraform-apply-codebuild"

github_acc_token                                            = "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"
source_provider                                             = "GITHUB"
authorization_type                                          = "PERSONAL_ACCESS_TOKEN"
codebuild_src_dir                                           = "pipeline"

emails_list                                                 = ["nicolas.lopezvaldez@rackspace.com"]