# frozen_string_literal: true

class UserIcons
  attr_reader :errors

  def initialize(user)
    @user = user
  end

  def save_all(original_icon_params, combined_icon_params)
    ActiveRecord::Base.transaction do
      @original_icon = @user.original_icons.create!(original_icon_params)
      @combined_icon = @original_icon.combined_icons.create!(combined_icon_params)
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors
    false
  end
end
