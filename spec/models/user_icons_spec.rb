# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIcons do
  subject(:user_icons) { described_class.new(user) }

  let(:user) { create(:user) }

  describe '#save_all' do
    context 'when params are valid' do
      subject(:save_all) { user_icons.save_all(original_icon_params, combined_icon_params) }

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
        expect(save_all).to be true
      end

      it 'creates both an original_icon and a combined_icon' do
        expect { save_all }
          .to change(OriginalIcon, :count).by(1)
          .and change(CombinedIcon, :count).by(1)
      end
    end

    context 'when params are invalid' do
      subject(:save_all) { user_icons.save_all(valid_original_icon_params, invalid_combined_icon_params) }

      let(:valid_original_icon_params) do
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
        expect(save_all).to be false
      end

      it 'sets the errors' do
        save_all
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
