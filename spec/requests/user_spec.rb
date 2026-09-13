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

    context 'when logged in' do
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

    context 'when logged out' do
      it 'does not delete the user and redirects' do
        user

        expect do
          delete user_path(user)
        end.not_to change(User, :count)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('ログインしてください')
      end
    end
  end
end
