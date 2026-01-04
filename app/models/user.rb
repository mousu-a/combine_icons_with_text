# frozen_string_literal: true

class User < ApplicationRecord
  has_many :original_icons, dependent: :destroy

  validates :uid, uniqueness: { scope: :provider }
  validates :uid, :provider, presence: true
end
