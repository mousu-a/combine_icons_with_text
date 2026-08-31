# frozen_string_literal: true

class AdminController < Admin::BaseController
  def index
    set_admin_managed_resource
  end
end
