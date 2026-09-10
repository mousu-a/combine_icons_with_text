# frozen_string_literal: true

%w[ラジオ参加 離席中 画面見れません].each do |text|
  OverlayText.find_or_create_by!(text:)
end
