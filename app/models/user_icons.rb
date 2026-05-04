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

  def saved_icons
    original_icons = OriginalIcon.with_attached_image.where(user: @user)
    combined_icons = CombinedIcon.with_attached_image.where(original_icon: original_icons)
    combined_icons_by_original_icon_id = combined_icons.group_by(&:original_icon_id)

    original_icons.index_with do |original_icon|
      combined_icons_by_original_icon_id[original_icon.id] || []
    end
  end
end
