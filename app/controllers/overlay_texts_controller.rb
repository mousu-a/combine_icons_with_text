# frozen_string_literal: true

class OverlayTextsController < ApplicationController
  before_action :require_admin, only: :create

  def create
    @overlay_text = OverlayText.new(overlay_text_params)
    if @overlay_text.save
      redirect_to admin_index_url, notice: '追加しました'
    else
      @icon_change_link = IconChangeLink.new
      render 'admin/index', status: :unprocessable_content
    end
  end

  private

  def overlay_text_params
    params.expect(overlay_text: [:text])
  end
end
