# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = OmniAuthUserResolver.find_or_create_user(auth)
    if user.persisted?
      login(user)
      redirect_to icons_path, alert: 'ログインしました。'
    else
      redirect_to root_path, alert: '認証に失敗しました。もう一度お試しください。'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました', status: :see_other
  end

  def auth_failure
    reset_session
    redirect_to root_path, alert: 'Googleログインがキャンセルされました', status: :see_other
  end

  private

  def login(user)
    session[:user_id] = user.id
  end

  def reset_session
    session.delete(:user_id)
  end
end
