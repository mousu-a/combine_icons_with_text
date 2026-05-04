# frozen_string_literal: true

class CanvasPresetCreator
  def call(_name, _started, _finished, _unique_id, payload)
    canvas_preset_params = payload[:canvas_preset_params]
    CanvasPreset.create(canvas_preset_params)
  end
end
