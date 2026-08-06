
<img src="app/assets/images/logo.png" alt="logo" width="300">

## 概要

文字入りアイコンメーカーは、自分のアイコンに1クリックでテキストを追加できるアプリです。

### 特徴
- 自分のアイコン画像に「今日はラジオ参加」などの文字を簡単に合成することができます。
- オンラインイベントなどで合成したアイコンにしておくことで、自分がラジオ参加していることを発言せずに伝えることができます。
- RemoやDiscordなどの、アイコン画像変更のリンク、ガイドが備わっているので、すぐに合成したアイコンに変更することが出来ます。

## URL
https://icon-font-mashup.com

## 使い方
- テキストを追加
UPした自分のアイコンに「今日はラジオ参加」などの文字を簡単に追加することができます。

- 編集したアイコンをダウンロード、保存
合成したアイコンはダウンロードでき、サイト上に保存されます（ログイン時のみ）

- UPしたアイコンを元に編集
一覧ページから、以前に保存したアイコンを元に合成を行えます。

- ページ下部に表示されている各サービスのリンクからアイコンを変更する


### 技術スタック

- Ruby 3.4.5
- Ruby on Rails 8.1.3
- Stimulus


### 環境構築
1. 任意のディレクトリにこのリポジトリのクローンを保存します。

```bash
git clone https://github.com/mousu-a/combine_icons_with_text.git
```

2. リポジトリに移動します。

```bash
cd combine_icons_with_text
```

3. Google Cloud で Google ログインに必要な `client_id` と `client_secret` を取得し、`.env` ファイルに設定します。

- `.env`ファイルを作成します。`.env` は環境変数を管理するファイルです（gitには含めません）。

```bash
touch .env
```

- Google Cloud で取得した `client_id` と` client_secret` を `.env`ファイルに設定します。

```dotenv
GOOGLE_CLIENT_ID=取得したclient_id
GOOGLE_CLIENT_SECRET=取得したclient_secret
```

4. セットアップを実行します。

```bash
bin/setup
```


### Lint、Test

- Lint

```bash
$ bin/lint
```

- Test

```bash
$ bundle exec rspec
```
