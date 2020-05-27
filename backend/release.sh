#!/usr/bin/env bash

PROJECT_NAME="food-truck-tracker"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [[ "${GIT_BRANCH}" = "master" ]]; then
    VERSION=${VERSION:-"$(git describe --abbrev=0 --tags)"}
elif [[ "${GIT_BRANCH}" = "develop" ]]; then
    VERSION="develop"
elif [[ "${GIT_BRANCH}" = "feature/deploy-to-ecs" ]]; then
    VERSION="deploy-to-ecs"
fi
echo ${VERSION}

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 430229884637.dkr.ecr.us-east-2.amazonaws.com

docker build -t ${PROJECT_NAME}:${VERSION} .
docker tag ${PROJECT_NAME}:${VERSION} 430229884637.dkr.ecr.us-east-2.amazonaws.com/${PROJECT_NAME}:${VERSION}
docker push 430229884637.dkr.ecr.us-east-2.amazonaws.com/${PROJECT_NAME}:${VERSION}
