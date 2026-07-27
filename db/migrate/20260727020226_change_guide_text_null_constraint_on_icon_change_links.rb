class ChangeGuideTextNullConstraintOnIconChangeLinks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :icon_change_links, :guide_text, false
  end
end
