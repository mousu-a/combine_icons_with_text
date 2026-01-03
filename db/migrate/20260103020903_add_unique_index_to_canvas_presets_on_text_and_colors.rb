class AddUniqueIndexToCanvasPresetsOnTextAndColors < ActiveRecord::Migration[8.0]
  def change
    add_index :canvas_presets,
            [:text, :text_color, :bg_color],
            unique: true,
            name: "index_canvas_presets_on_text_and_colors"
  end
end
