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
* 必要なDDLの投入

#### API Server

```
mix deps.get
```

### 起動方法

```
mix phoenix.server
```

## V1 API リファレンス

[sana_server](https://github.com/Project-ShangriLa/sana_server) レポジトリを参照のこと

## Curl

```
curl -v http://localhost:4000/anime/v1/twitter/follwer/status?accounts=usagi_anime,kinmosa_anime
```
