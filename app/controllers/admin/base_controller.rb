# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    private

    def set_admin_managed_resources
      @icon_change_links = IconChangeLink.all
      @overlay_texts = OverlayText.all
    end
  end
end
