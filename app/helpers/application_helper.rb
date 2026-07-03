# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: '文字入りアイコンメーカー',
      reverse: true,
      charset: 'utf-8',
      description: '文字入りアイコンメーカーは、オンラインイベントで自分がラジオ参加していることを、発言せずに伝えることができない問題を解決する画像合成サービスです。',
      og: {
        title: :title,
        type: 'website',
        site_name: '文字入りアイコンメーカー',
        description: :description,
        image: image_url('logo.png'),
        url: 'https://icon-font-mashup.com',
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@mousu_a'
      }
    }
  end
end
