# frozen_string_literal: true

class User < ApplicationRecord
  has_many :original_icons, dependent: :destroy

  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }
  validates :uid, :provider, presence: true

  def saveable?(original_icon_params)
    original_icon = original_icons.find_by(id: original_icon_params[:id])
    !icons_limit_reached?(target_icon: original_icon)
  end

  def icons_limit_reached?(target_icon: nil)
    if target_icon
      target_icon.combined_icons.count >= CombinedIcon::MAX_COMBINED_ICONS_COUNT
    else
      original_icons.count >= OriginalIcon::MAX_ORIGINAL_ICONS_COUNT
    end
  end
end
