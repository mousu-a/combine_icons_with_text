# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Icons' do
  scenario 'uploads an image, shows the preview, and enables the editing features' do
    visit new_icon_path
    expect(page).to have_text '文字入りアイコン作成'

    edit_controls = 'fieldset[data-ui-state-target="editControls"]'
    expect(page).to have_css("#{edit_controls}[disabled]")

    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')

    expect(page).to have_css('#icon-preview', visible: :visible)
    expect(page).to have_css("#{edit_controls}:not([disabled])")
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

    expect(page).to have_css('#icon-preview', visible: :visible)
    expect(page).to have_field('表示する文字', disabled: false)
    expect(page).to have_text 'drop-sample.png'
  end

  scenario 'toggles the text background' do
    visit new_icon_path
    attach_file 'upload-icon', Rails.root.join('spec/files/dummy_3MB.jpg')

    expect(page).to have_unchecked_field('文字に背景をつける')
    expect(page).to have_field('背景色', disabled: true)

    check '文字に背景をつける'
    expect(page).to have_field('背景色', disabled: false)
  end

  def drop_sample_image
    page.execute_script(<<~JS)
      (() => {
        const bytes = Uint8Array.from(
          atob('#{sample_png_data}'),
          (character) => character.charCodeAt(0),
        );
        const file = new File([bytes], 'drop-sample.png', { type: 'image/png' });
        const transfer = new DataTransfer();
        const dropZone = document.querySelector('[data-ui-state-target="dropZone"]');
        transfer.items.add(file);
        dropZone.dispatchEvent(new DragEvent('dragenter', { bubbles: true, dataTransfer: transfer }));
        dropZone.dispatchEvent(new DragEvent('drop', { bubbles: true, dataTransfer: transfer }));
      })();
    JS
  end

  def sample_png_data
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wl2nAAAAABJRU5ErkJggg=='
  end
end
