#Sana 紗凪
ShangriLa Anime API Server for Twitter Data

## Sana Server システム概要

### 説明

* アニメに関するTwitterのデータを返すREST形式のAPIサーバーのElixir Phoenix実装です。
* ShangriLa Anime API のサブセットです。

### サーバーシステム要件

* Elixir 1.0+
* フレームワーク Phoenix

### インストール

#### Erlang and Elixir

##### OSX

```
homebrew install elixir
```

##### Linux

* Erlang RPM
* https://www.erlang-solutions.com/downloads/download-erlang-otp

* Elixir

```
git clone https://github.com/elixir-lang/elixir.git
cd elixir/
git checkout v1.1.1
make clean test
```

```
export PATH="$PATH:/path/to/elixir/bin"
```

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
curl -v http://localhost:4000/anime/v1/twitter/follower/status?accounts=usagi_anime,kinmosa_anime | jq .

curl -v http://localhost:4000/anime/v1/twitter/follower/history?account=usagi_anime | jq .
curl -v "http://localhost:4000/anime/v1/twitter/follower/history?account=usagi_anime&end_date=1407562541" | jq .
```

## ルーティングの確認

```
mix phoenix.routes
```
