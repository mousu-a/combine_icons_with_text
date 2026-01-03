# frozen_string_literal: true

class OverlayText < ApplicationRecord
  validates :text, presence: true, uniqueness: true
end
