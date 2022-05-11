#!/bin/bash

## change to the working directory
pwd
ls
cd pipeline

## Performing Terrafom init

echo "=========================================================="
echo ">> TERRAFORM INIT"
echo "=========================================================="

terraform init
if [ $? -ne 0 ]; then
    echo ">>> TERRAFORM INIT failed. Abort execution <<<"
    exit 1
fi
echo ""
echo ""
echo ""

## Performing Terrafom plan on all subdir
echo "=========================================================="
echo ">> TERRAFORM PLAN"
echo "=========================================================="

terraform plan -out=TerraformPlanOutput.json
if [ $? -ne 0 ]; then
    echo ">>> TERRAFORM PLAN failed. Abort execution <<<"
    exit 1
fi
echo ""
echo ""
echo ""

exit 0
