---
description: LocalStack の指定サービス・概念のドキュメントを調べて日本語で解説し、要点をプロジェクトに記録する
argument-hint: <lambda|api-gateway|cloudformation|compose|credentials|cli|spring>
allowed-tools: [WebFetch, Read, Edit, Write]
---

# LocalStack ドキュメント解説コマンド

ユーザーが調べたいトピック: $ARGUMENTS

## やること

1. `$ARGUMENTS` からトピックを特定する
2. 下記のドキュメントマップから対応する URL を選ぶ
3. `WebFetch` でそのページを取得する
4. 以下の形式で **日本語** で回答する
5. ドキュメントから得た要点を `lambda/CLAUDE.md` の `## ドキュメントから学んだこと` セクションに追記する

### ステップ 5 の詳細: 要点の記録

回答後、以下の手順で `lambda/CLAUDE.md` を更新する。

- `## ドキュメントから学んだこと` セクションがなければ末尾に新規作成する
- そのセクション内に `### [トピック名]` のサブセクションを追加する
- 内容は「このプロジェクトの実装に直接役立つ事実」のみ。感想・説明・手順の繰り返しは書かない
- すでに同トピックのサブセクションがあれば上書きではなく差分を追記する

## ドキュメントマップ

| トピック | URL | 注目ポイント |
| --- | --- | --- |
| lambda | <https://docs.localstack.cloud/user-guide/aws/lambda/> | LAMBDA_EXECUTOR、サポートランタイム |
| api-gateway | <https://docs.localstack.cloud/user-guide/aws/api-gateway/> | URL パターン、Lambda プロキシ統合 |
| cloudformation | <https://docs.localstack.cloud/user-guide/aws/cloudformation/> | サポートリソースタイプ、デプロイコマンド |
| compose / docker | <https://docs.localstack.cloud/getting-started/installation/> | SERVICES 変数、ヘルスチェック |
| credentials | <https://docs.localstack.cloud/references/configuration/> | 認証情報の扱い、環境変数一覧 |
| cli / awslocal | <https://docs.localstack.cloud/user-guide/integrations/aws-cli/> | awslocal ラッパー、endpoint-url |
| spring | <https://docs.spring.io/spring-cloud-function/docs/current/reference/html/aws.html> | FunctionInvoker、Gradle 依存関係 |

トピックがマップにない場合は `https://docs.localstack.cloud` をトップとして WebFetch で検索し、最も関連するページを取得する。

## 回答フォーマット

### [トピック] とは

LocalStack におけるこのサービス・概念の役割を 2〜3 文で説明する。
実際の AWS との違いがあれば触れる。

### 読むべきドキュメント

- **URL**: 取得したページの URL
- **見るべきセクション**: ページ内の具体的なセクション名
- **このプロジェクトとの関連**: なぜ今読む必要があるか 1 文で

### Gotchas (LocalStack 固有の注意点)

実際の AWS とは異なる動作や、ハマりやすいポイントを箇条書きで列挙する。

### このプロジェクトでの次のアクション

ドキュメントを読んだ後に取るべき具体的な 1 ステップを示す。
