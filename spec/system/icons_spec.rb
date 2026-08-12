# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons' do
  scenario 'uploads an image and shows the preview' do
    visit new_icon_path

    expect(page).to have_text 'アイコン合成'
    expect(page).to have_no_css('#icon-preview', visible: :visible)
    expect(page).to have_no_link('← アイコン一覧へ')
    expect(page).to have_field('表示する文字', disabled: true)

    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')

    expect(page).to have_css('#icon-preview', visible: :visible)
    expect(page).to have_field('表示する文字', disabled: false)
  end

  scenario 'enables the download after entering text' do
    visit new_icon_path
    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')

    fill_in '表示する文字', with: '耳だけ参加'
    expect(page).to have_css('a.download-button[aria-disabled="false"]')

    fill_in '表示する文字', with: ''
    expect(page).to have_css('a.download-button[aria-disabled="true"]')
  end

  scenario 'toggles the text background' do
    visit new_icon_path
    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')

    expect(page).to have_unchecked_field('文字に背景をつける')
    expect(page).to have_field('背景色', disabled: true)

    check '文字に背景をつける'
    expect(page).to have_field('背景色', disabled: false)

    uncheck '文字に背景をつける'
    expect(page).to have_field('背景色', disabled: true)
  end

  scenario 'restores the original image when the background becomes transparent' do
    visit new_icon_path
    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')
    expect(page).to have_css('#icon-preview[src^="blob:"]', visible: :visible)
    original_pixel = canvas_pixel

    check '文字に背景をつける'
    expect(canvas_pixel).not_to eq(original_pixel)

    find_by_id('opacityRange').set(0)
    expect(canvas_pixel).to eq(original_pixel)

    find_by_id('opacityRange').set(1)
    expect(canvas_pixel).not_to eq(original_pixel)

    find_by_id('opacityRange').set(0)

    expect(canvas_pixel).to eq(original_pixel)
  end

  def canvas_pixel
    page.evaluate_script(<<~JS)
      (() => {
        const canvas = document.querySelector('[data-canvas-target="canvas"]');
        return Array.from(canvas.getContext('2d').getImageData(10, canvas.height - 10, 1, 1).data);
      })()
    JS
  end
end
