# Lambda サブプロジェクト — 方針ドキュメント

## ゴール

Spring Cloud Function (Java / Gradle) を使って「Hello World」を返すだけのシンプルな REST API を作る。
インフラは CloudFormation で定義し、LocalStack 上でローカル動作させる。

## 技術スタック

| 要素 | 技術 |
| --- | --- |
| 言語・フレームワーク | Java / Spring Boot / Spring Cloud Function |
| ビルドツール | Gradle |
| インフラ定義 | AWS CloudFormation |
| AWS サービス | Lambda + API Gateway |
| ローカル実行環境 | LocalStack (Docker Compose) |

## このプロジェクトで学ぶこと

1. **Lambda ZIP デプロイの仕組み** — Gradle でビルドした JAR を ZIP 化して LocalStack にアップロードする流れ
2. **API Gateway → Lambda ルーティング** — HTTP リクエストが Lambda に届くまでの構成
3. **CloudFormation テンプレートの書き方** — Lambda 関数・API Gateway・IAM ロールをコードで定義する
4. **ローカル検証ループ** — ビルド → デプロイ → curl で呼び出し → ログ確認のサイクル

## 想定プロジェクト構成 (今後作成予定)

```text
lambda/
├── CLAUDE.md           # このファイル
├── compose.yaml        # LocalStack 起動定義
├── template.yaml       # CloudFormation テンプレート
├── src/                # Spring Boot アプリケーション
│   ├── build.gradle
│   └── src/main/java/...
└── deploy.sh           # ビルド → デプロイ → 動作確認スクリプト
```

## 各ステップで読むべきドキュメント

### ステップ 1: compose.yaml を書く前に

- **URL**: <https://docs.localstack.cloud/getting-started/installation/>
- **見るべきセクション**: "Docker Compose" のセクション
- **注目ポイント**:
  - `SERVICES` 環境変数 (有効にするサービスを列挙する)
  - `healthcheck` の設定 (LocalStack が起動完了するまで待つ仕組み)
  - `LAMBDA_EXECUTOR` 変数 (学習目的なら `local` で十分)

### ステップ 2: CloudFormation テンプレートを書く前に

- **URL**: <https://docs.localstack.cloud/user-guide/aws/cloudformation/>
- **見るべきセクション**: "Supported Resource Types"
- **注目ポイント**: どのリソースタイプが使えるか (Lambda・API Gateway が含まれているか確認)

### ステップ 3: Lambda の設定をする前に

- **URL**: <https://docs.localstack.cloud/user-guide/aws/lambda/>
- **見るべきセクション**: "Configuration" と "Supported Runtimes"
- **注目ポイント**:
  - `LAMBDA_EXECUTOR` の各モード (`local` / `docker`) の違い
  - Java ランタイムのサポート状況

### ステップ 4: Spring Cloud Function のコードを書く前に

- **URL**: <https://docs.spring.io/spring-cloud-function/docs/current/reference/html/aws.html>
- **見るべきセクション**: "Getting Started" と "FunctionInvoker"
- **注目ポイント**:
  - `FunctionInvoker` — CloudFormation の `Handler` フィールドに指定するクラス
  - Gradle の依存関係 (`spring-cloud-function-adapter-aws`)

### ステップ 5: AWS CLI でデプロイする前に

- **URL**: <https://docs.localstack.cloud/user-guide/integrations/aws-cli/>
- **見るべきセクション**: "awslocal" のセクション
- **注目ポイント**:
  - `awslocal` ラッパーとは何か (`--endpoint-url http://localhost:4566` を自動付与する)
  - 通常の `aws` コマンドとの違い

### ステップ 6: API Gateway 経由で呼び出す前に

- **URL**: <https://docs.localstack.cloud/user-guide/aws/api-gateway/>
- **見るべきセクション**: "Invoking the API"
- **注目ポイント**:
  - LocalStack の呼び出し URL パターン (実際の AWS と異なる)
  - `_user_request_` セグメントが LocalStack 固有である点

## 重要概念 (基礎)

### LocalStack エンドポイント

すべての AWS SDK・CLI 呼び出しは `http://localhost:4566` に向ける。
`awslocal` コマンドを使えばこの指定を自動化できる。

### Lambda Executor モード

- `local`: Lambda 関数を LocalStack プロセス内で直接実行。起動が速く学習に向いている
- `docker`: Lambda 関数を別の Docker コンテナで実行。実際の AWS に近い動作だが重い

学習目的では `local` モードから始めるとよい。

### フェイク認証情報

LocalStack は AWS の認証情報を検証しない。空でなければ何でもよい。
慣例として以下を使う:

```properties
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
AWS_DEFAULT_REGION=ap-northeast-1
```

### LocalStack の API Gateway URL パターン

実際の AWS:

```text
https://{api-id}.execute-api.{region}.amazonaws.com/{stage}/path
```

LocalStack:

```text
http://localhost:4566/restapis/{api-id}/{stage}/_user_request_/path
```

`_user_request_` セグメントは LocalStack 固有。curl でテストするときに必要。

---

## ドキュメントから学んだこと

`/localstack-docs <トピック>` を実行すると、ここに要点が自動追記される。
次のセッションでもこの内容を会話の前提として使う。
