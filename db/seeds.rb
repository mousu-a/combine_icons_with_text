# frozen_string_literal: true

if Rails.env.production?
  Rails.logger.info('Skip loading seed data in the production environment.')
  return
end

load Rails.root.join('db/seeds/icon_change_links.rb')
load Rails.root.join('db/seeds/canvas_presets.rb')
