#!/bin/sh
set -e

# CHECKPOINT: init コンテナ内で JAR をビルドする
#             gradlew はプロジェクトルート（/app）にマウントされている
cd /app
./gradlew shadowJar

# CHECKPOINT: sam deploy がローカルパスの JAR を S3 にアップロードしてから CloudFormation をデプロイする
#             --resolve-s3  : S3 バケットの作成とアップロードを自動処理
#             --no-confirm-changeset : 確認プロンプトをスキップ（非インタラクティブ実行に必要）
#             AWS_ENDPOINT_URL が設定されているため --endpoint-url の指定は不要
sam deploy \
  --template-file /app/template.yaml \
  --stack-name lambda-container-stack-local \
  --resolve-s3 \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides Env=local \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset

# BOILERPLATE: スタックの Outputs を表示。ApiId がここに出るので URL を組み立てる
echo ">>> Stack outputs:"
sam list stack-outputs --stack-name lambda-container-stack-local

# GOTCHA: LocalStack の API Gateway URL は通常の AWS と異なり _user_request_ セグメントが入る
echo ">>> API URL pattern: http://localhost:4566/restapis/{ApiId}/Prod/_user_request_/hello"

echo ">>> Done"
