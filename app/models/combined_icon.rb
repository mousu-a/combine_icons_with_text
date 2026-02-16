# frozen_string_literal: true

class CombinedIcon < ApplicationRecord
  MAX_FILE_SIZE = 6
  MAX_COMBINED_ICONS_COUNT = 5

  belongs_to :original_icon

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200], preprocessed: true
  end

  validates :image, image_content: { max_file_size: MAX_FILE_SIZE }
  validate :limit_per_user, on: :create

  private

  def limit_per_user
    return unless original_icon.combined_icons.count >= MAX_COMBINED_ICONS_COUNT

    errors.add(:base, :limit_per_user, max_icons_count: MAX_COMBINED_ICONS_COUNT)
  end
end
