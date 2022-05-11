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
repository_name                                             = "nlopezn/lambda_test_repo"
repository_branch_name                                      = "main"
tf_version                                                  = "1.1.9"
codebuild_project_name_plan                                 = "terraform-plan-codebuild"
codebuild_project_name_apply                                = "terraform-apply-codebuild"

buildspec_plan_yml                                          = "buildspec_plan.yml"
buildspec_apply_yml                                         = "buildspec_apply.yml"

source_provider                                             = "GITHUB"
codebuild_src_dir                                           = "pipeline"

emails_list
