# frozen_string_literal: true

module Admin
  class OverlayTextsController < Admin::BaseController
    def create
      @overlay_text = OverlayText.new(overlay_text_params)
      if @overlay_text.save
        redirect_to admin_index_url, notice: '追加しました'
      else
        set_admin_managed_resource
        render 'admin/index', status: :unprocessable_content
      end
    end

    private

    def overlay_text_params
      params.expect(overlay_text: [:text])
    end
  end
end
