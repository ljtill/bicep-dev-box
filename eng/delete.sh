#!/bin/bash

RED='\033[0;31m'

while getopts s:p: option
do
    case "${option}" in
        s) subscription_id=${OPTARG};;
        p) parameter_file=${OPTARG};;
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

if [ -z "$parameter_file" ]; then
    parameter_file="./src/parameters/main.json"
fi

echo "==> Parsing parameter file..."
network_settings_data=$(cat $parameter_file | jq -r '.parameters.networkSettings.value')

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to parse parameter file"
    exit 1
fi

echo "==> Parsing parameter file..."
devcenter_settings_data=$(cat $parameter_file | jq -r '.parameters.devcenterSettings.value')
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to parse parameter file"
    exit 1
fi

if [ -n "$CI" ]; then
    echo "==> Skipping resource deletion..."
else
    echo "==> Deleting devcenter resources..."
    az group delete --name $(echo $devcenter_settings_data | jq -r '.resourceGroup.name')

    echo "==> Deleting network resources..."
    az group delete --name $(echo $network_settings_data | jq -r '.resourceGroup.name')
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to delete network resources"
    exit 1
fi