#!/bin/bash
################################################################
# Run: upgrade-apps.sh <NEW_VER>
# e.g. upgrade-apps.sh v0.1.4
################################################################

# exit when any command fails
set -eo pipefail

cd "$(dirname "$0")"
cd ..

# Verify if new version was informed
NEW_VER=$1
if [[ $# -eq 0 ]]; then
    echo "*****************************************************************"
    read -n 1 -p "No new container tag was informed. Do you wish to continue (y/n)? " answer
    echo
    case ${answer:0:1} in
        y|Y )
            echo Yes
            read -rep $'Please enter the new:\n' NEW_VER
        ;;
        * )
            echo No
            exit 1
        ;;
    esac
fi

echo "new version: $NEW_VER"

# Simulate release of the new docker images
docker tag nginx:1.25.2 dbaltor/nginx:$NEW_VER

# Push new version to dockerhub
docker push dbaltor/nginx:$NEW_VER

# Update image tag
sed -i "s/dbaltor\/nginx:.*/dbaltor\/nginx:$NEW_VER/g" ./environments/dev/my-app-1/deployment.yaml
sed -i "s/dbaltor\/nginx:.*/dbaltor\/nginx:$NEW_VER/g" ./environments/dev/my-app-2/deployment.yaml

# Commit and push
git add .
git commit -m "upgrade image to $NEW_VER"
git push
