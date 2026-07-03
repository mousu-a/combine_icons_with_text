
![logo](app/assets/images/logo.png)

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
一覧ページから、UPしたアイコンを元に合成を行えます。

## 環境

- Ruby 3.4.5
- Ruby on Rails 8.1.3
- Stimulus

## 開発環境

### セットアップ、起動

- セットアップ

```bash
$ git clone https://github.com/mousu-a/combine_icons_with_text.git
$ cd combine_icons_with_text
$ bin/setup
```

- 起動

```bash
$ bin/dev
```

- 起動後

  - 通常ログイン：下記URLからログインします（しなくても使えます）
    http://localhost:3000/

  - お好きなアイコンをアップロードし、テキストを挿入してみましょう
    http://localhost:3000/icons/new

  - ログインしていれば、保存後一覧ページにアイコンが保存されていることを確認できます
    http://localhost:3000/icons/index

### Lint、Test

- Lint

```bash
$ bin/lint
```

- Test

```bash
$ bundle exec rspec
```
