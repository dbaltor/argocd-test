#!/bin/bash
################################################################
# Run: upgrade-kustomize.sh <APP_NAME> <ENV_NAME> <NEW_VER>
# e.g. upgrade-kustomize.sh nginx staging v0.1.4
################################################################

# exit when any command fails
set -eo pipefail

cd "$(dirname "$0")"
cd ..

# Verify if new version was informed
APP_NAME=$1
ENV=$2
NEW_VER=$3
if [[ $# -eq 0 ]]; then
    echo "***************************************************************************************************"
    read -n 1 -p "Application name, environment, and new version must be informed. Do you wish to continue (y/n)? " answer
    echo
    case ${answer:0:1} in
        y|Y )
            echo Yes
            read -rep $'Please enter the application name:\n' APP
            echo
            read -rep $'Please enter the environment name:\n' ENV
            echo
            read -rep $'Please enter the new version:\n' NEW_VER
        ;;
        * )
            echo No
            exit 1
        ;;
    esac
elif [[ $# -ne 3 ]]; then
  echo "******************************************************************************" 
  echo "Application name, environment, and new version must be informed in this order."
  echo "E.g.: $0 <app-name> <env> <tag>"
  echo "******************************************************************************"
  exit 1   
fi

echo "image: $APP_NAME"
echo "environment: $ENV"
echo "new version: $NEW_VER"

# Simulate release of the new docker images
docker tag nginx:1.25.2 dbaltor/nginx:$NEW_VER

# Push new version to dockerhub
docker push dbaltor/nginx:$NEW_VER

# Update image tag
sed -i "s/newTag: .*/newTag: ${NEW_VER}/g" ./environments/${ENV}/${APP_NAME}/kustomization.yaml

# Commit and push
git add .
git commit -m "upgrade $APP_NAME in $ENV to $NEW_VER"
git push
