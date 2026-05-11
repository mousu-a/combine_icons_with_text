# frozen_string_literal: true

class UsersController < ApplicationController
  def destroy
    current_user.destroy!
    session.delete(:user_id)
    redirect_to root_path, notice: '退会しました。これまでご愛顧いただき誠にありがとうございました。'
  end
end
