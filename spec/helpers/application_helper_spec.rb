# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#default_meta_tags' do
    it 'returns the default meta tags as a hash' do
      meta_tags = helper.default_meta_tags

      expect(meta_tags[:site]).to eq('文字入りアイコンメーカー')
      expect(meta_tags[:description]).to eq('文字入りアイコンメーカーは、オンラインイベントで自分がラジオ参加していることを、発言せずに伝えることができない問題を解決する画像合成サービスです。')
    end

    it 'includes Open Graph and Twitter meta tags' do
      meta_tags = helper.default_meta_tags

      expect(meta_tags[:og][:site_name]).to eq('文字入りアイコンメーカー')
      expect(meta_tags[:twitter][:card]).to eq('summary_large_image')
    end
  end
end
