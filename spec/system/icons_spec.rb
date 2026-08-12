# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons' do
  scenario 'uploads an image and shows the preview' do
    visit new_icon_path

    expect(page).to have_text '文字入りアイコン作成'
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

  scenario 'uploads an image by dropping it on the completed image preview' do
    visit new_icon_path

    drop_sample_image

    expect(page).to have_text 'drop-sample.png'
    expect(page).to have_css('#icon-preview[src^="blob:"]', visible: :visible)
    expect(page).to have_field('表示する文字', disabled: false)
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
    expect_opacity_round_trip_to_restore(original_pixel)
  end

  def expect_opacity_round_trip_to_restore(original_pixel)
    expect(canvas_pixel).not_to eq(original_pixel)
    change_opacity(0)
    expect(canvas_pixel).to eq(original_pixel)
    change_opacity(1)
    expect(canvas_pixel).not_to eq(original_pixel)
    change_opacity(0)
    expect(canvas_pixel).to eq(original_pixel)
  end

  def change_opacity(value) = find_by_id('opacityRange').set(value)

  def drop_sample_image
    page.execute_script(<<~JS)
      (() => {
        const bytes = Uint8Array.from(
          atob('#{sample_png_data}'),
          (character) => character.charCodeAt(0),
        );
        const file = new File([bytes], 'drop-sample.png', { type: 'image/png' });
        const transfer = new DataTransfer();
        const dropZone = document.querySelector('[data-icons-target="dropZone"]');
        transfer.items.add(file);
        dropZone.dispatchEvent(new DragEvent('dragenter', { bubbles: true, dataTransfer: transfer }));
        dropZone.dispatchEvent(new DragEvent('drop', { bubbles: true, dataTransfer: transfer }));
      })();
    JS
  end

  def sample_png_data
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wl2nAAAAABJRU5ErkJggg=='
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
