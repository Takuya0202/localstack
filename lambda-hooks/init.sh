#!/bin/bash

set -e

echo ">>> Creating S3 bucket"
awslocal s3 mb s3://lambda-hooks-bucket

echo ">>> Uploading JAR"
# BOILERPLATE: ホストの build/libs/ をマウントした先からアップロードする
awslocal s3 cp \
  /opt/build/lambda-hooks-0.0.1-SNAPSHOT.jar \
  s3://lambda-hooks-bucket/lambda-hooks.jar

echo ">>> Deploying CloudFormation stack"
awslocal cloudformation deploy \
  --template-file /opt/template.yaml \
  --stack-name lambda-hooks-stack \
  --capabilities CAPABILITY_IAM

echo ">>> Done"
