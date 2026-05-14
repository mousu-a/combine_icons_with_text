# frozen_string_literal: true

module Admin
  class IconChangeLinksController < ApplicationController
    before_action :require_admin, only: :create
    before_action :set_admin_managed_resources, only: :create

    def create
      @icon_change_link = IconChangeLink.new(icon_change_link_params)
      if @icon_change_link.save
        redirect_to admin_index_url, notice: '追加しました'
      else
        @overlay_text = OverlayText.new
        render 'admin/index', status: :unprocessable_content
      end
    end

    private

    def icon_change_link_params
      # TODO: カラムを追加次第、change_guideを追加
      params.expect(icon_change_link: %i[url site_name])
    end

    def set_admin_managed_resources
      @icon_change_links = IconChangeLink.all
      @overlay_texts = OverlayText.all
    end
  end
end
