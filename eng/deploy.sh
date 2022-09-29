#!/bin/bash

RED='\033[0;31m'

while getopts s:c: option
do
    case "${option}" in
        s) subscription_id=${OPTARG};;
        c) config_file=${OPTARG};;
    esac
done

echo "=> Starting deployment process..."

# TODO: Add role assignment
# TODO: Add script root invocation

if [ -z "$subscription_id" ]; then
    echo -e "${RED}Missing script argument (-s subscriptionId)"
    exit 1
fi

if [ -z "$config_file" ]; then
    config_file="./src/configs/main.json"
fi

echo "==> Switching subscription..."
az account set --subscription "$subscription_id"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to switch subscription"
    exit 1
fi

if [ -n "$CI" ]; then
    echo "==> Validating resources..."
    az deployment sub what-if \
        --name "Microsoft.Deployment.Bash" \
        --location "uksouth" \
        --template-file "./src/main.bicep" \
        --parameters $config_file
else
    echo "==> Deploying resources..."
    az deployment sub create \
        --name "Microsoft.Deployment.Bash" \
        --location "uksouth" \
        --template-file "./src/main.bicep" \
        --parameters $config_file
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to deploy resources"
    exit 1
fi
