# frozen_string_literal: true

class IconChangeLink < ApplicationRecord
  validates :site_name, :url, presence: true, uniqueness: true
  validates :guide_text, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
end
