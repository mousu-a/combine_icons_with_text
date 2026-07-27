# frozen_string_literal: true

class HomeController < ApplicationController
  def welcome
    redirect_to new_icon_path if current_user
  end

  def terms; end
  def privacy; end
end
