# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { create(:user) }

  context 'when logged out' do
    scenario 'logs in' do
      sign_in_with_google user

      expect(page).to have_content 'ログインしました'
    end

    scenario 'cancels logging in' do
      visit auth_failure_path

      expect(page).to have_content 'Googleログインがキャンセルされました'
    end

    scenario 'signs up with no name' do
      sign_in_with_google user, name: ''

      expect(page).to have_content 'ログインしました'
    end
  end

  context 'when logged in' do
    before { sign_in_with_google user }

    scenario 'logs out' do
      # TODO: ログインボタンのヘッダー化後削除
      visit welcome_path
      click_on 'ログアウト'

      expect(page).to have_content 'ログアウトしました'
    end
  end
end
