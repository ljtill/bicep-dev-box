#!/bin/bash

RED='\033[0;31m'

while getopts s:c: option
do
    case "${option}" in
        s) subscription_id=${OPTARG};;
        c) config_file=${OPTARG};;
    esac
done

if [ -z "$subscription_id" ]; then
    echo -e "${RED}=> Missing script argument (-s subscriptionId)..."
    exit 1
fi

# TODO: Add script root invocation
if [ -z "$config_file" ]; then
    $config_file="./src/configs/main.json"
fi

echo "Switching subcription"
az account set --subscription "$subscription_id"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to switch subscription"
    exit 1
fi

echo "=> Deleting devbox resources..."
network_resource_group=$(cat ./main.json | jq -r '.parameters.config.value.network.resourceGroup.name')
while true; do
    read -r -p "Are you sure you want to perform this operation? (y/n):" answer
    case $answer in
        [Yy]* ) az group delete -n x; break;;
        [Nn]* ) echo -e "${RED}Operation cancelled."; exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

echo "=> Deleting network resources..."
devbox_resource_group=$(cat ./main.json | jq -r '.parameters.config.value.devbox.resourceGroup.name')

while true; do
    read -r -p "Are you sure you want to perform this operation? (y/n):" answer
    case $answer in
        [Yy]* ) az group delete -n x; break;;
        [Nn]* ) echo -e "${RED}Operation cancelled."; exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

# echo "Deleting resources"
# az group delete --name ""

# if [ $? -ne 0 ]; then
#     echo "Failed to delete resources"
#     exit 1
# fi