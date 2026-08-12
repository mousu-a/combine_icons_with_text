# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  describe 'GET /welcome' do
    context 'when logged in' do
      let(:user) { create(:user) }

      before { login user }

      it 'redirects to the new icon page' do
        get welcome_path

        expect(response).to redirect_to(new_icon_path)
      end
    end

    context 'when logged out' do
      it 'returns http success' do
        get welcome_path

        expect(response).to have_http_status(:ok)
        hero_logo = response.parsed_body.at_css('.hero-logo img[alt="文字入りアイコンメーカー"]')
        expect(hero_logo['src']).to include('logo-')
      end
    end
  end

  describe 'GET /terms' do
    it 'returns http success' do
      get terms_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /privacy' do
    it 'returns http success' do
      get privacy_path

      expect(response).to have_http_status(:ok)
    end
  end
end
