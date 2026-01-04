class RemoveUniqueIndexFromIconChangeLinks < ActiveRecord::Migration[8.0]
  def change
    remove_index :icon_change_links,
      [:site_name, :url],
      unique: true,
      name: "index_icon_change_links_on_site_name_and_url"
  end
end
