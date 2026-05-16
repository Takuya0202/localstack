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
  --stack-name lambda-hooks-stack-local \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides Env=local
  # CHECKPOINT: --parameter-overrides で Parameters の値を上書きする
  #             本番なら Env=prod を渡す。init.sh は常にローカル用なので local 固定

# CHECKPOINT: Outputs から API ID を取得して URL を組み立てる
# GOTCHA: LocalStack の URL は http://localhost:4566/restapis/{id}/Prod/_user_request_/path
echo ">>> Fetching API URL"
API_ID=$(awslocal cloudformation describe-stacks \
  --stack-name lambda-hooks-stack-local \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiId`].OutputValue' \
  --output text)
echo ">>> API URL: http://localhost:4566/restapis/${API_ID}/Prod/_user_request_/hello"

echo ">>> Done"
