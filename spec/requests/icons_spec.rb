# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons' do
  describe 'GET /icons/new' do
    it 'returns http success' do
      get new_icon_path

      expect(response).to have_http_status(:ok)
    end

    it 'hides the icon list link when logged out' do
      get new_icon_path

      expect(response.body).not_to include('← アイコン一覧へ')
      expect(response.body).to include('Googleアカウントでログインする')
    end

    it 'shows the icon list link when logged in' do
      login create(:user)

      get new_icon_path

      expect(response.body).to include('← アイコン一覧へ')
    end
  end

  describe 'GET /icons' do
    it 'returns http success' do
      get icons_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /icons' do
    let(:user) { create(:user) }
    let(:original_icon) { create(:original_icon, user:) }

    before { login user }

    it 'saves the combined icon' do
      expect do
        post icons_path, params: {
          original_icon: { id: original_icon.id },
          combined_icon: { image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg') },
          canvas_preset: { text: 'sample', text_color: '#000000', bg_color: '#ffffff' }
        }
      end.to change(CombinedIcon, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('画像を保存しました。')
    end
  end

  describe 'DELETE /icons/:id' do
    let(:user) { create(:user) }
    let(:original_icon) { create(:original_icon, user:) }

    before { login user }

    it 'deletes the icon' do
      original_icon_id = original_icon.id

      expect do
        delete icon_path(original_icon_id, original_icon_id:)
      end.to change(OriginalIcon, :count).by(-1)

      expect(response).to redirect_to(icons_url)
      follow_redirect!
      expect(response.body).to include('アイコンを削除しました。')
    end

    it 'does not delete the icon if unauthorized' do
      other_user_icon = create(:original_icon)

      expect do
        delete icon_path(other_user_icon, original_icon_id: other_user_icon.id)
      end.not_to change(OriginalIcon, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
