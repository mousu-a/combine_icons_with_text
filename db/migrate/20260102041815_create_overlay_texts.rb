class CreateOverlayTexts < ActiveRecord::Migration[8.0]
  def change
    create_table :overlay_texts do |t|
      t.string :text, null: false

      t.timestamps
    end
  end
end
