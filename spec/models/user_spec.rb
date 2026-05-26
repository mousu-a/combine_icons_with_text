# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { create(:user) }

  describe '#icons_limit_reached?' do
    context 'when target_icon is present' do
      subject(:icons_limit_reached?) { user.icons_limit_reached?(target_icon: original_icon) }

      let!(:original_icon) { create(:original_icon, user:) }

      it 'returns false before reaching the limit' do
        create_list(
          :combined_icon,
          CombinedIcon::MAX_COMBINED_ICONS_COUNT - 1,
          original_icon:
        )

        expect(icons_limit_reached?).to be(false)
      end

      it 'returns true after reaching the limit' do
        create_list(
          :combined_icon,
          CombinedIcon::MAX_COMBINED_ICONS_COUNT,
          original_icon:
        )

        expect(icons_limit_reached?).to be(true)
      end
    end

    context 'when target_icon is absent' do
      subject(:icons_limit_reached?) { user.icons_limit_reached?(target_icon: nil) }

      it 'returns false before reaching the limit' do
        create_list(
          :original_icon,
          OriginalIcon::MAX_ORIGINAL_ICONS_COUNT - 1,
          user:
        )

        expect(icons_limit_reached?).to be(false)
      end

      it 'returns true after reaching the limit' do
        create_list(
          :original_icon,
          OriginalIcon::MAX_ORIGINAL_ICONS_COUNT,
          user:
        )

        expect(icons_limit_reached?).to be(true)
      end
    end
  end

  describe '#saveable?' do
    subject(:saveable?) { user.saveable?(original_icon_params) }

    context 'when original_icon id is present' do
      let(:original_icon_params) { { id: original_icon.id } }
      let!(:original_icon) { create(:original_icon, user:) }

      it 'returns true when the found original_icon has not reached the combined_icon limit' do
        create_list(
          :combined_icon,
          CombinedIcon::MAX_COMBINED_ICONS_COUNT - 1,
          original_icon:
        )

        expect(saveable?).to be(true)
      end

      it 'returns false when the found original_icon has reached the combined_icon limit' do
        create_list(
          :combined_icon,
          CombinedIcon::MAX_COMBINED_ICONS_COUNT,
          original_icon:
        )

        expect(saveable?).to be(false)
      end
    end

    context 'when original_icon id is absent' do
      let(:original_icon_params) { { image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg') } }

      it 'returns true when the user has not reached the original_icon limit' do
        create_list(
          :original_icon,
          OriginalIcon::MAX_ORIGINAL_ICONS_COUNT - 1,
          user:
        )

        expect(saveable?).to be(true)
      end
    end

    context 'when original_icon id is present but does not exist' do
      let(:original_icon_params) { { id: 99_999 } }

      it 'returns true when the user has not reached the original_icon limit' do
        create_list(
          :original_icon,
          OriginalIcon::MAX_ORIGINAL_ICONS_COUNT - 1,
          user:
        )

        expect(saveable?).to be(true)
      end
    end
  end
end
