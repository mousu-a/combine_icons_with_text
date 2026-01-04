# frozen_string_literal: true

class CanvasPreset < ApplicationRecord
  validates :text, :text_color, presence: true
  validates :text, uniqueness: { scope: %i[text_color bg_color] }
end
