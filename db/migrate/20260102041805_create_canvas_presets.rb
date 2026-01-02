class CreateCanvasPresets < ActiveRecord::Migration[8.0]
  def change
    create_table :canvas_presets do |t|
      t.string :text, null: false
      t.string :text_color, null: false
      t.string :bg_color

      t.timestamps
    end
  end
end
