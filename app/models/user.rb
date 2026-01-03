# frozen_string_literal: true

class User < ApplicationRecord
  has_many :original_icons, dependent: :destroy
end
