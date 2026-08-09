# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin' do
  describe 'GET /admin' do
    context 'when logged in as an admin' do
      let(:admin) { create(:user, admin: true) }

      before { login(admin) }

      it 'returns http success' do
        get admin_index_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not an admin' do
      let(:user) { create(:user) }

      before { login(user) }

      it 'redirects to the icons page' do
        get admin_index_path

        expect(response).to redirect_to(icons_path)
        follow_redirect!
        expect(response.body).to include('権限がありません')
      end
    end
  end

  describe 'POST /admin/icon_change_links' do
    let(:admin) { create(:user, admin: true) }

    before { login(admin) }

    context 'with valid parameters' do
      it 'adds a new icon change link' do
        expect do
          post admin_icon_change_links_path, params: {
            icon_change_link: { url: 'https://example.com', site_name: 'サンプル', guide_text: '手順' }
          }
        end.to change(IconChangeLink, :count).by(1)

        expect(response).to redirect_to(admin_index_url)
        follow_redirect!
        expect(response.body).to include('追加しました')
      end
    end

    context 'with invalid parameters' do
      it 'does not add the icon change link' do
        expect do
          post admin_icon_change_links_path, params: {
            icon_change_link: { url: '', site_name: 'サンプル', guide_text: '手順' }
          }
        end.not_to change(IconChangeLink, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('サイトURLを入力してください')
      end
    end
  end

  describe 'POST /admin/overlay_texts' do
    let(:admin) { create(:user, admin: true) }

    before { login(admin) }

    context 'with valid parameters' do
      it 'adds a new overlay text' do
        expect do
          post admin_overlay_texts_path, params: {
            overlay_text: { text: 'サンプルテキスト' }
          }
        end.to change(OverlayText, :count).by(1)

        expect(response).to redirect_to(admin_index_url)
        follow_redirect!
        expect(response.body).to include('追加しました')
      end
    end

    context 'with invalid parameters' do
      it 'does not add the overlay text' do
        expect do
          post admin_overlay_texts_path, params: { overlay_text: { text: '' } }
        end.not_to change(OverlayText, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('合成するテキストを入力してください')
      end
    end
  end
end
