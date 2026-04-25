# frozen_string_literal: true

ActiveSupport::Notifications.subscribe('icons.create') do |name, started, finished, unique_id, payload|
  CanvasPresetCreator.new.call(name, started, finished, unique_id, payload)
end
