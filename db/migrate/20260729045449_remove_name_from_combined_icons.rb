class RemoveNameFromCombinedIcons < ActiveRecord::Migration[8.1]
  def change
    remove_column :combined_icons, :name, :string
  end
end
