# frozen_string_literal: true

icon_change_links = [
  {
    site_name: 'Remo',
    url: 'https://live.remo.co/my-events',
    guide_text: <<~TEXT.chomp
      ログイン後、右上のアバターをクリック。
      編集をクリック。
      編集をクリック。
      プロフィール画像の変更をクリック。
      保存をクリック。
    TEXT
  },
  {
    site_name: 'Zoom',
    url: 'https://us04web.zoom.us/myhome',
    guide_text: <<~TEXT.chomp
      ログイン後、真ん中に出ている自分のアバターをクリック。
      左下の「変更」をクリック。
      右下の「保存」をクリック。
    TEXT
  },
  {
    site_name: 'Slack',
    url: 'https://slack.com/signin#/signin',
    guide_text: <<~TEXT.chomp
      ログイン後、どこでもいいのでワークスペースに参加（自分で作成しても問題ないです）。
      サイドバー一番下のアイコンをクリック。
      プロフィールをクリック。
      右のプロフィール欄にある一番上の「編集」をクリック。
      写真をアップロードをクリック。
      変更を保存をクリック。
    TEXT
  },
  {
    site_name: 'Discord',
    url: 'https://discord.com/channels/@me',
    guide_text: <<~TEXT.chomp
      左下のアイコンをクリック。
      プロフィールを編集をクリック。
      真ん中のアバターをクリック。
      アバターを変更をクリック。
      画像をアップロード。
      適用をクリック。
    TEXT
  },
  {
    site_name: 'Google',
    url: 'https://www.google.com/',
    guide_text: <<~TEXT.chomp
      画面右上のアバターをクリック。
      出てきたモーダルのアバターをクリック。
    TEXT
  }
]

icon_change_links.each do |attributes|
  IconChangeLink.find_or_create_by!(site_name: attributes[:site_name]) do |record|
    record.url = attributes[:url]
    record.guide_text = attributes[:guide_text]
  end
end
