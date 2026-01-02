class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :site_name, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
