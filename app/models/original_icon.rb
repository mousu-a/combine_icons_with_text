# frozen_string_literal: true

class OriginalIcon < ApplicationRecord
  belongs_to :user

  has_many :combined_icons, dependent: :destroy
end
