#!/bin/bash

while getopts s:c: option
do
    case "${option}" in
        s) subscription_id=${OPTARG};;
        c) config_file=${OPTARG};;
    esac
done

if [ -z "$subscription_id" ]; then
    echo "=> Missing script argument (-s subscriptionId)..."
    exit 1
fi

# TODO: Add script root invocation
if [ -z "$config_file" ]; then
    $config_file="./src/configs/main.json"
fi

echo "=> Switching subscription..."
az account set --subscription "$subscription_id"

if [ $? -ne 0 ]; then
    echo "=> Failed to switch subscription"
    exit 1
fi

# TODO: Add script root invocation
echo "=> Deploying resources..."
az deployment sub create \
    --name "Microsoft.Deployment" \
    --location "uksouth" \
    --template-file "./src/main.bicep" \
    --parameters $config_file

if [ $? -ne 0 ]; then
    echo "=> Failed to deploy resources"
    exit 1
fi

# echo "Creating assignment"
# az role assignment create \
#     --role "Contributor" \
#     --assignee-object-id "$(az ad signed-in-user show --query objectId -o tsv)" \
#     --scope "/subscriptions/$1"

# if [ $? -ne 0 ]; then
#     echo "Failed to create role assignment"
#     exit 1
# fi

