# frozen_string_literal: true

class IconChangeLink < ApplicationRecord
  validates :site_name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
end
