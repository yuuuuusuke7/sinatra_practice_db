# sinatra_practice_db

## 1. リポジトリの説明
フィヨルドブートキャンプの「WebアプリからのDB利用」のプラクティス。pgを使って、sinatraで作成したメモアプリのデータ保存先をpostgresSQLに変更。

## 2. 概要
DBはPostgreSQLを使う。
SQL実行にprepared statementを使う。

## 3. アプリケーションを立ち上げるための手順
- sinatraのgemをinstallする
- リモートリポジトリをクローンする
```git clone https://github.com/yuuuuusuke7/sinatra_practice.git```
- ターミナル上で```sinatra_practice```に移動して、```ruby app.rb```を実行する
- ブラウザで```http://localhost:4567/memos```にアクセスする