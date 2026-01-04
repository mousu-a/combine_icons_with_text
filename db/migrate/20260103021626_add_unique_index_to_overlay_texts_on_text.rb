class AddUniqueIndexToOverlayTextsOnText < ActiveRecord::Migration[8.0]
  def change
    add_index :overlay_texts, :text, unique: true
  end
end
