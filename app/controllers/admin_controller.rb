# frozen_string_literal: true

class AdminController < Admin::BaseController
  before_action :require_admin, only: :index
  before_action :set_admin_managed_resources, only: :index

  def index
    @icon_change_link = IconChangeLink.new
    @overlay_text = OverlayText.new
  end
end
