#!/bin/bash

set -e

subscription_id="$1"

if [ -z "$subscription_id" ]; then
    echo "Provide a subscription id"
    exit 1
fi

echo "Switching subcription"
az account set --subscription "$1"

if [ $? -ne 0 ]; then
    echo "Failed to switch subscription"
    exit 1
fi

echo "Parsing config file"
cat "$2" | jq -r '.[]'

if [ $? -ne 0 ]; then
    echo "Failed to parse config file"
    exit 1
fi


echo "Deleting resources"
az group delete --name ""

if [ $? -ne 0 ]; then
    echo "Failed to deletex resources"
    exit 1
fi