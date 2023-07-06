#!/bin/bash

name=$(echo $RANDOM | base64 | head -c 8 | tr -dc '[:alpha:]' | tr '[:upper:]' '[:lower:]'; echo)
contents="$(cat ./src/parameters/main.json)"

# Network

contents="$(echo $contents | jq '.parameters.networkSettings.value.resourceGroup.name = "'network-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.networkSettings.value.resources.virtualNetwork.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.networkSettings.value.resources.securityGroup.name = "'$name'"')"

# Compute

contents="$(echo $contents | jq '.parameters.computeSettings.value.resourceGroup.name = "'compute-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.computeSettings.value.resources.galleries[0].name = "'$name'"')"

# Identity

contents="$(echo $contents | jq '.parameters.identitySettings.value.resourceGroup.name = "'identity-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.identitySettings.value.resources.managedIdentity.name = "'$name'"')"

# DevCenter

contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resourceGroup.name = "'devbox-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.networkConnection.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.networkConnection.resourceGroup = "'interface-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.devcenter.name = "'$name'"')"

echo -E "${contents}" > ./src/parameters/main.json
