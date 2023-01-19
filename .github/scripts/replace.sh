#!/bin/bash

name=$(echo $RANDOM | base64 | head -c 8 | tr -dc '[:alpha:]' | tr '[:upper:]' '[:lower:]'; echo)
contents="$(cat ./src/parameters/main.json)"

# Network

contents="$(echo $contents | jq '.parameters.networkSettings.value.resourceGroup.name = "'network-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.networkSettings.value.resourceGroup.location = "uksouth"')"
contents="$(echo $contents | jq '.parameters.networkSettings.value.resources.virtualNetwork.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.networkSettings.value.resources.securityGroup.name = "'$name'"')"

# DevCenter

contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resourceGroup.name = "'devbox-$GITHUB_RUN_ID-bash'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resourceGroup.location = "uksouth"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.managedIdentity.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.computeGallery.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.networkConnection.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.devcenter.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.projects.name = "'$name'"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.projects.description = "Deployed by GitHub Actions"')"
contents="$(echo $contents | jq '.parameters.devcenterSettings.value.resources.projects.pools[0].name = "'$name'"')"

echo -E "${contents}" > ./src/parameters/main.json
