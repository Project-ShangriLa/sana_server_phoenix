#Sana 紗凪
ShangriLa Anime API Server for Twitter Data

## Sana Server システム概要

### 説明

* アニメに関するTwitterのデータを返すREST形式のAPIサーバーのElixir Phoenix実装です。
* ShangriLa Anime API のサブセットです。

### サーバーシステム要件

* Elixir
* フレームワーク Phoenix

### インストール

#### DB
* MySQL、もしくはMySQL互換サーバーのインストール
* anime_admin_development データベース作成
* 必要なDDLの投入 [ShangriLa DDL](https://github.com/Project-ShangriLa/shangrila/tree/master/DDL)

#### API Server

```
mix deps.get
```

### 起動方法

dev
```
mix phoenix.server
```

production
```
MIX_ENV=prod mix compile.protocols
MIX_ENV=prod PORT=4000 mix phoenix.server
```

参考)http://www.phoenixframework.org/v0.6.2/docs/running-in-production-or-performance-testing

## ライセンス

Apache 2 license

## V1 API リファレンス

[sana_server](https://github.com/Project-ShangriLa/sana_server) レポジトリを参照のこと

## Curl

```
curl -v http://localhost:4000/anime/v1/twitter/follwer/status?accounts=usagi_anime,kinmosa_anime | jq .

curl -v http://localhost:4000/anime/v1/twitter/follwer/history?account=usagi_anime | jq .
curl -v "http://localhost:4000/anime/v1/twitter/follwer/history?account=usagi_anime&end_date=1407562541" | jq .
```

## ルーティングの確認

```
mix phoenix.routes
```
