# frozen_string_literal: true

class IconsController < ApplicationController
  before_action :set_icon_change_links
  def index
    @saved_icons = {}
    return unless current_user

    @saved_icons = UserIcons.new(current_user).saved_icons
  end

  def new
    @canvas_presets = CanvasPreset.order(created_at: :desc).limit(5)
    @user_icons = nil
  end

  def create
    save_canvas_preset(canvas_preset_params)
    render_redirect_path unless current_user

    @user_icons = UserIcons.new(current_user)
    if @user_icons.save_all(original_icon_params, combined_icon_params)
      flash[:notice] = '画像を保存しました！'
      render_redirect_path
    else
      render json: { error: @user_icons.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def set_icon_change_links
    @links = IconChangeLink.all
  end

  # TODO: ログイン処理を作ったら削除
  def current_user
    @current_user ||= User.find(1)
  end

  def original_icon_params
    params.expect(original_icon: [:image])
  end

  def combined_icon_params
    params.expect(combined_icon: %i[image name])
  end

  def canvas_preset_params
    params.expect(canvas_preset: %i[text text_color bg_color])
  end

  def save_canvas_preset(preset_params)
    ActiveSupport::Notifications.instrument('icons.create', canvas_preset_params: preset_params)
  end

  def render_redirect_path
    render json: { redirect_url: icons_path }
  end
end
