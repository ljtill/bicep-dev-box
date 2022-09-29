#!/bin/bash

RED='\033[0;31m'

while getopts s:c: option
do
    case "${option}" in
        s) subscription_id=${OPTARG};;
        c) config_file=${OPTARG};;
    esac
done

echo "=> Starting deletion process..."

# TODO: Add script root invocation

if [ -z "$subscription_id" ]; then
    echo -e "${RED}Missing script argument (-s subscriptionId)..."
    exit 1
fi

echo "==> Switching subcription..."
az account set --subscription "$subscription_id"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to switch subscription"
    exit 1
fi

if [ -z "$config_file" ]; then
    config_file="./src/configs/main.json"
fi

echo "==> Parsing config file..."
config_data=$(cat $config_file | jq -r '.parameters.config.value')

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to parse config file"
    exit 1
fi

if [ -n "$CI" ]; then
    echo "==> Skipping resource deletion..."
else
    echo "==> Deleting devbox resources..."
    az group delete --name $(echo $config_data | jq -r '.devbox.resourceGroup.name')

    echo "==> Deleting network resources..."
    az group delete --name $(echo $config_data | jq -r '.network.resourceGroup.name')
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to delete network resources"
    exit 1
fi