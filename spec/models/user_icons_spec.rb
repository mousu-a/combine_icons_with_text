# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIcons do
  subject(:user_icons) { described_class.new(user) }

  let(:user) { create(:user) }

  # TODO: has_oneだった時の名残でhas_one用のテストになっているが、
  #   サイトに保存した既存のアイコンを元に合成する機能を追加する　で合わせて変更する
  describe '#save_all' do
    context 'when the user does not have an original_icon' do
      let(:original_icon_params) do
        attributes_for(:original_icon).merge(
          image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg')
        )
      end
      let(:combined_icon_params) do
        attributes_for(:combined_icon).merge(
          image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg')
        )
      end

      it 'returns true' do
        expect(user_icons.save_all(original_icon_params, combined_icon_params)).to be true
      end

      it 'creates an original_icon' do
        expect do
          user_icons.save_all(original_icon_params, combined_icon_params)
        end.to change(OriginalIcon, :count).by(1)
      end

      it 'creates a combined_icon' do
        expect do
          user_icons.save_all(original_icon_params, combined_icon_params)
        end.to change(CombinedIcon, :count).by(1)
      end
    end

    context 'when the user already has an original_icon' do
      before do
        create(:original_icon, user: user)
      end

      let(:original_icon_params) do
        attributes_for(:original_icon).merge(
          image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg')
        )
      end

      let(:combined_icon_params) do
        attributes_for(:combined_icon).merge(
          image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg')
        )
      end

      it 'returns true' do
        expect(user_icons.save_all(original_icon_params, combined_icon_params)).to be true
      end

      it 'does not create a new original_icon' do
        expect do
          user_icons.save_all(original_icon_params, combined_icon_params)
        end.not_to change(OriginalIcon, :count)
      end

      it 'creates a combined_icon' do
        expect do
          user_icons.save_all(original_icon_params, combined_icon_params)
        end.to change(CombinedIcon, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let(:original_icon_params) do
        attributes_for(:original_icon).merge(
          image: fixture_file_upload('spec/files/dummy_3MB.jpg', 'image/jpeg')
        )
      end
      let(:invalid_combined_icon_params) do
        attributes_for(:combined_icon).merge(
          image: fixture_file_upload('spec/files/sample.txt', 'text/plain')
        )
      end

      it 'returns false' do
        expect(user_icons.save_all(original_icon_params, invalid_combined_icon_params)).to be false
      end

      it 'sets the errors' do
        user_icons.save_all(original_icon_params, invalid_combined_icon_params)
        expect(user_icons.errors[:image]).to include('text/plain は許可されていない形式です')
      end
    end
  end

  describe '#saved_icons' do
    subject(:saved_icons) { user_icons.saved_icons }

    context 'when the user has icons' do
      let!(:original_icon) { create(:original_icon, user: user) }
      let!(:combined_icon) { create(:combined_icon, original_icon: original_icon) }

      it 'returns a hash of the user’s icons' do
        expect(saved_icons).to eql(original_icon => [combined_icon])
      end
    end

    context 'when the user has original icons but no combined icons' do
      let!(:original_icon) { create(:original_icon, user: user) }

      it 'returns a hash with original icons and empty combined icons' do
        expect(saved_icons).to eql(original_icon => [])
      end
    end

    context 'when the user has no original icons' do
      it 'returns an empty hash' do
        expect(saved_icons).to eql({})
      end
    end
  end
end
