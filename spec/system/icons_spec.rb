# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Icons', :js do
  scenario 'shows the icons page' do
    visit new_icon_path
    assert_text 'アイコン合成'
  end

  scenario 'shows the original image and preview after uploading an image' do
    visit new_icon_path
    attach_file 'upload-icon', Rails.root.join('spec/fixtures/files/dummy.png')

    expect(page).to have_css('img.icon-preview', visible: :visible)
    expect(page).to have_css('img.icon', visible: :visible)
  end
end
