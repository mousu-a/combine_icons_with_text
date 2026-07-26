class AddGuideTextToIconChangeLinks < ActiveRecord::Migration[8.1]
  def change
    add_column :icon_change_links, :guide_text, :string
  end
end
