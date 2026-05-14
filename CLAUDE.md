# LocalStack 学習プロジェクト

## プロジェクト目的

LocalStack に入門し、様々な AWS サービスをローカル環境で試す学習用リポジトリ。
コードを「動かす」だけでなく、**なぜそう書くのか・どこを読んだらわかるのか** を理解することを最優先とする。

## Claude に対するルール

### ルール 1: コードを書く前にドキュメントを提示する

設定ファイル (compose.yaml、CloudFormation テンプレート、AWS CLI コマンドなど) を書く際は、
必ずその前に以下の形式でドキュメントを提示すること。

```
このコードを書く前に読むべきドキュメント:
- URL: <ドキュメントの URL>
- 見るべきセクション: <具体的なセクション名>
- なぜ読むか: <このプロジェクトとの関連>
```

### ルール 2: LocalStack の仕組みを基礎レベルで説明する

LocalStack に関係する操作を行う際は、必要に応じて以下の観点を 3〜5 文で説明する。

- LocalStack とは何か (Docker で AWS サービスをローカルエミュレートするツール)
- エンドポイント: すべての AWS API 呼び出しが `http://localhost:4566` に向く
- 無料 (Community) / Pro の区別: 今回使うサービスが無料枠か確認する
- 実際の AWS との主な違い

深く掘り下げる必要はない。「基礎的な仕組みを理解した上でドキュメントを読める」レベルで十分。

### ルール 3: 設定値の「なぜ」を説明する

自明でない設定値には必ず理由を添える。

例:
- `AWS_ACCESS_KEY_ID=test` → LocalStack は認証情報を検証しないため、空でなければ何でもよい
- `LAMBDA_EXECUTOR=docker` → Lambda 関数を Docker コンテナ内で実行することで、実際の AWS 環境に近い動作になる

### ルール 4: コードに注釈を付ける

生成するコードには以下のコメントタグで重要度を示す。

- `# CHECKPOINT: ...` — 理解してから進むべき箇所。ここは立ち止まって考える
- `# BOILERPLATE: ...` — 定型コード。内容を理解しなくてもよいが、何をしているかは説明する
- `# GOTCHA: ...` — 実際の AWS と動作が異なる LocalStack 固有の注意点

## LocalStack ドキュメントの入口

| 目的 | URL |
| --- | --- |
| LocalStack の全体像を把握する | <https://docs.localstack.cloud/getting-started/> |
| Docker Compose でのセットアップ方法 | <https://docs.localstack.cloud/getting-started/installation/> |
| 各 AWS サービスのサポート状況確認 | <https://docs.localstack.cloud/references/coverage/> |
| 設定値一覧 (環境変数) | <https://docs.localstack.cloud/references/configuration/> |

## プロジェクト構成

```
localstack/
├── CLAUDE.md              # このファイル (プロジェクト全体のルール)
├── README.md
├── lambda-hooks/          # Lambda + API Gateway — LocalStack Init Hooks パターン
│   └── CLAUDE.md
└── lambda-container/      # Lambda + API Gateway — 別コンテナ (depends_on) パターン
    └── CLAUDE.md
```
