class AddNameToCombinedIcons < ActiveRecord::Migration[8.0]
  def change
    add_column :combined_icons, :name, :string, null: false
  end
end
