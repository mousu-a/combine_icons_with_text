# frozen_string_literal: true

unless Rails.env.development?
  Rails.logger.info('Skip loading seed data outside the development environment.')
  return
end

load Rails.root.join('db/seeds/icon_change_links.rb')
load Rails.root.join('db/seeds/canvas_presets.rb')
