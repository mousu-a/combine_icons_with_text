class AddNameToCombinedIcons < ActiveRecord::Migration[8.0]
  def up
    add_column :combined_icons, :name, :string

    execute <<~SQL.squish
      UPDATE combined_icons
      SET name = '名称未設定'
      WHERE name IS NULL
    SQL

    change_column_null :combined_icons, :name, false
  end

  def down
    remove_column :combined_icons, :name
  end
end
