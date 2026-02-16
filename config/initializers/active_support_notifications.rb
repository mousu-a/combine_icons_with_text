# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  ActiveSupport::Notifications.subscribe('icons.create', CanvasPresetCreator.new)
end
