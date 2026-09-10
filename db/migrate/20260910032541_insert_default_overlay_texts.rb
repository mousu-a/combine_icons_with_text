class InsertDefaultOverlayTexts < ActiveRecord::Migration[8.1]
  TEXTS = ["ラジオ参加", "離席中", "画面見れません"].freeze

  def up
    TEXTS.each do |text|
      OverlayText.find_or_create_by!(text: text)
    end
  end

  def down
    OverlayText.where(text: TEXTS).destroy_all
  end
end
