# frozen_string_literal: true

class IconChangeLink < ApplicationRecord
  validates :site_name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
