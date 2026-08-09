# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe 'DELETE /logout' do
    let(:user) { create(:user) }

    before { login user }

    it 'logs out' do
      delete logout_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('ログアウトしました')
    end
  end

  describe 'DELETE /users/:id' do
    let(:user) { create(:user) }

    before { login user }

    it 'deletes a user account' do
      expect do
        delete user_path(user)
      end.to change(User, :count).by(-1)

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('退会しました')
    end
  end
end
