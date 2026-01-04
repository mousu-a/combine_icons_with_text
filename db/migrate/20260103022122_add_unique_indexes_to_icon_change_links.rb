class AddUniqueIndexesToIconChangeLinks < ActiveRecord::Migration[8.0]
  def change
    add_index :icon_change_links, :site_name, unique: true
    add_index :icon_change_links, :url, unique: true

    add_index :icon_change_links,
              [:site_name, :url],
              unique: true,
              name: "index_icon_change_links_on_site_name_and_url"
  end
end
