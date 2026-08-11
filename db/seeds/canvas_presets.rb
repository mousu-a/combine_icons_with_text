# frozen_string_literal: true

CanvasPreset.find_or_create_by!(
  text: 'テスト用プリセット',
  text_color: '#ffffff',
  bg_color: '#000000'
)
