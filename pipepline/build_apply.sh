#!/bin/bash

## change to the working directory
#cd pipeline/

## Performing Terrafom init
echo "=========================================================="
echo ">> TERRAFORM INIT"
echo "=========================================================="
terraform init
if [ $? -ne 0 ]; then
    echo ">>> TERRAFORM INIT failed on. Abort execution <<<"
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

## Performing Terrafom apply
echo "=========================================================="
echo ">> TERRAFORM APPLY"
echo "=========================================================="
terraform apply -input=false -auto-approve TerraformPlanOutput.json
if [ $? -ne 0 ]; then
    echo ">>> TERRAFORM APPLY failed. Abort execution <<<"
    exit 1
fi
cd ..
echo ""
echo ""
echo ""

exit 0