# Lambda サブプロジェクト — 別コンテナパターン

## インフラ初期化方式

**Docker Compose の `depends_on: condition: service_healthy`** を使う。
`init` サービスが LocalStack の healthcheck 通過後に起動し、CloudFormation デプロイを実行して終了する。
外部ツール（SAM CLI など）が必要な場合でも任意のイメージを使えるのが特徴。

比較対象 → `lambda-hooks/`（LocalStack Init Hooks 方式）

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
| 初期化コンテナ | `amazon/aws-cli` ベースの init サービス |

## このプロジェクトで学ぶこと

1. **Lambda ZIP デプロイの仕組み** — Gradle でビルドした JAR を ZIP 化して LocalStack にアップロードする流れ
2. **API Gateway → Lambda ルーティング** — HTTP リクエストが Lambda に届くまでの構成
3. **CloudFormation テンプレートの書き方** — Lambda 関数・API Gateway・IAM ロールをコードで定義する
4. **`depends_on: condition: service_healthy`** — コンテナの起動順序制御と healthcheck の連携

## 想定プロジェクト構成 (今後作成予定)

```text
lambda-container/
├── CLAUDE.md           # このファイル
├── compose.yaml        # localstack + init の2サービス構成
├── init.sh             # init コンテナが実行するデプロイスクリプト
├── template.yaml       # CloudFormation テンプレート
└── src/                # Spring Boot アプリケーション
    ├── build.gradle
    └── src/main/java/...
```

`compose.yaml` の構造イメージ:

```yaml
services:
  localstack:
    # ... (healthcheck あり)

  init:
    image: amazon/aws-cli
    depends_on:
      localstack:
        condition: service_healthy   # healthcheck 通過後に起動
    entrypoint: ["/bin/sh", "/init.sh"]
    # init.sh を実行して exit 0 で終了するだけ
```

## 各ステップで読むべきドキュメント

### ステップ 1: compose.yaml を書く前に

- **URL**: <https://docs.localstack.cloud/getting-started/installation/>
- **見るべきセクション**: "Docker Compose" のセクション
- **注目ポイント**:
  - `SERVICES` 環境変数 (有効にするサービスを列挙する)
  - `healthcheck` の設定（`condition: service_healthy` の前提条件）

- **URL**: <https://docs.docker.com/compose/how-tos/startup-order/>
- **見るべきセクション**: "Control startup and shutdown order"
- **注目ポイント**:
  - `depends_on` の `condition: service_healthy` の書き方
  - healthcheck が通らないと init サービスが起動しない仕組み

### ステップ 2: CloudFormation テンプレートを書く前に

- **URL**: <https://docs.localstack.cloud/user-guide/aws/cloudformation/>
- **見るべきセクション**: "Supported Resource Types"
- **注目ポイント**: どのリソースタイプが使えるか (Lambda・API Gateway が含まれているか確認)

### ステップ 3: Lambda の設定をする前に

- **URL**: <https://docs.localstack.cloud/user-guide/aws/lambda/>
- **見るべきセクション**: "Configuration" と "Supported Runtimes"
- **注目ポイント**: Java ランタイムのサポート状況

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

### Lambda 実行モード（LocalStack 3.0 以降）

LocalStack 3.0 以降、`LAMBDA_EXECUTOR` 変数は廃止された。
Lambda 関数は常に Docker コンテナとして実行される（旧 `docker-reuse` 相当）。
そのため `compose.yaml` で `/var/run/docker.sock` のマウントが必須。

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
