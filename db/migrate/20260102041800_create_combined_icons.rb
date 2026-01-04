class CreateCombinedIcons < ActiveRecord::Migration[8.0]
  def change
    create_table :combined_icons do |t|
      t.references :original_icon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
