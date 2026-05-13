# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :require_admin, only: :index
  def index
    @icon_change_links = IconChangeLink.all
    @overlay_texts = OverlayText.all

    @icon_change_link = IconChangeLink.new
    @overlay_text = OverlayText.new
  end
end
