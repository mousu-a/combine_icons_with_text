
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
合成したアイコンはダウンロードでき、サイト上に保存されます。（ログイン時のみ）

- UPしたアイコンを元に編集
一覧ページから、以前に保存したアイコンを元に合成を行えます。

- ページ下部に表示されている各サービスのリンクからアイコンを変更する
ページ下部に各サービスのリンクと、アイコン変更までの動線が書かれており、すぐにアイコンを変更することが可能です。

<img width="1481" height="653" alt="スクリーンショット 2026-08-05 18 03 39" src="https://github.com/user-attachments/assets/09f2223e-8f00-4bcd-901c-fb257051d0e9" />
<img width="1464" height="644" alt="スクリーンショット 2026-08-05 18 04 37" src="https://github.com/user-attachments/assets/feef4fa5-6a16-4584-8777-9cf8be2b83ae" />
<img width="1110" height="618" alt="スクリーンショット 2026-08-05 18 04 47" src="https://github.com/user-attachments/assets/002124c7-1847-4d69-bfbd-e4bac4d27f0e" />

---
### 技術スタック

- Ruby 4.0.6
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
