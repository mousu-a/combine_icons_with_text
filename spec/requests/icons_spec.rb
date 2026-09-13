# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons' do
  let(:user) { create(:user) }

  describe 'GET /icons/new' do
    it 'returns http success' do
      get new_icon_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('文字入りアイコンメーカー トップ')
      expect(response.body).to include('文字入りアイコン作成')
    end

    it 'hides the icon list link when logged out' do
      get new_icon_path

      expect(response.body).not_to include('← アイコン一覧へ')
      expect(response.body).to include('Googleアカウントでログインする')
    end

    it 'shows the icon list link when logged in' do
      login user

      get new_icon_path

      expect(response.body).to include('← アイコン一覧へ')
      expect(response.body).not_to include('Googleアカウントでログインする')
    end

    it 'shows recognizable icons for supported services' do
      create_supported_service_links

      get new_icon_path

      %w[remo zoom slack discord google].each do |service_key|
        expect(response.body).to include("service-icon--#{service_key}")
        expect(response.body).to include("#{service_key}-logo")
      end
    end

    it 'shows overlay texts registered in the database as text options' do
      OverlayText.find_or_create_by!(text: 'よく使われる文字')

      get new_icon_path

      page = Capybara::Node::Simple.new(response.body)
      expect(page).to have_css('.btn-text-option', text: 'よく使われる文字')
    end
  end

  def create_supported_service_links
    %w[Remo Zoom Slack Discord Google].each_with_index do |site_name, index|
      IconChangeLink.find_or_create_by!(site_name:) do |record|
        record.url = "https://example.com/#{index}"
        record.guide_text = 'プロフィール設定を開く'
      end
    end
  end

  describe 'GET /icons' do
    context 'when logged in' do
      before { login user }

      it 'returns http success' do
        get icons_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged out' do
      it 'redirects to the root page' do
        get icons_path

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('ログインしてください')
      end
    end
  end

  describe 'POST /icons' do
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

    it 'does not save the combined icon if params are invalid' do
      expect do
        post icons_path, params: {
          original_icon: { id: original_icon.id },
          combined_icon: { image: fixture_file_upload('spec/files/sample.txt', 'text/plain') },
          canvas_preset: { text: 'sample', text_color: '#000000', bg_color: '#ffffff' }
        }
      end.not_to change(CombinedIcon, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('text/plain は許可されていない形式です')
    end
  end

  describe 'DELETE /icons/:id' do
    let(:original_icon) { create(:original_icon, user:) }

    context 'when logged in' do
      before { login user }

      it 'deletes the icon' do
        original_icon_id = original_icon.id

        expect do
          delete icon_path(original_icon, original_icon_id:)
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

    context 'when logged out' do
      it 'does not delete the icon and redirects' do
        original_icon_id = original_icon.id

        expect do
          delete icon_path(original_icon, original_icon_id:)
        end.not_to change(OriginalIcon, :count)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('ログインしてください')
      end
    end
  end
end
