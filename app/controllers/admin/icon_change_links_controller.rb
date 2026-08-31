# frozen_string_literal: true

module Admin
  class IconChangeLinksController < Admin::BaseController
    def create
      @icon_change_link = IconChangeLink.new(icon_change_link_params)
      if @icon_change_link.save
        redirect_to admin_index_url, notice: '追加しました'
      else
        set_admin_managed_resource
        render 'admin/index', status: :unprocessable_content
      end
    end

    private

    def icon_change_link_params
      params.expect(icon_change_link: %i[url site_name guide_text])
    end
  end
end
