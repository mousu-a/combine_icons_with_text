# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private

    def require_admin
      redirect_to icons_path, alert: '権限がありません' unless current_user&.admin?
    end

    def set_admin_managed_resources
      @icon_change_links = IconChangeLink.all
      @overlay_texts = OverlayText.all
    end
  end
end
