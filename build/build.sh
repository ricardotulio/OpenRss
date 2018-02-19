#!/bin/bash

LOCAL_IMAGE_TAG='openrss:latest'
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
REMOTE_IMAGE_TAG=$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$LOCAL_IMAGE_TAG
REMOTE_IMAGE_URL=$REMOTE_IMAGE_TAG

cd ..
docker build -t $LOCAL_IMAGE_TAG . --no-cache
docker tag $LOCAL_IMAGE_TAG $REMOTE_IMAGE_TAG

`aws ecr get-login --no-include-email --region us-east-1`

docker push $REMOTE_IMAGE_TAG

cd ./build

sed -e "s/\$IMAGE_URL/${REMOTE_IMAGE_URL/\//\\/}/g" service.yml.example > service.yml

aws cloudformation remove-stack --stack-name openrss
aws cloudformation create-stack --stack-name openrss --template-body file://service.yml

rm service.yml
