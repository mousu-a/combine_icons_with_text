# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OriginalIcon do
  describe 'Validations' do
    context 'when all attributes are valid' do
      let(:original_icon) { build(:original_icon) }

      it 'is valid' do
        expect(original_icon).to be_valid
      end
    end
  end

  describe 'Custom Validations' do
    context 'when the image has a disallowed MIME type' do
      let(:original_icon) { build(:original_icon, :disallowed_content_type) }

      it 'is invalid' do
        expect(original_icon).not_to be_valid
        expect(original_icon.errors[:image]).to include('text/plain は許可されていない形式です')
      end
    end

    context 'when the file size is within the limit' do
      let(:original_icon) { build(:original_icon, :within_size_limit) }

      it 'is valid' do
        expect(original_icon).to be_valid
      end
    end

    context 'when the file size exceeds the limit' do
      let(:original_icon) { build(:original_icon, :exceeds_size_limit) }

      it 'is invalid' do
        expect(original_icon).not_to be_valid
        expect(original_icon.errors[:image]).to include("元アイコンは#{OriginalIcon::MAX_FILE_SIZE}MB以下のファイルを選択してください")
      end
    end
  end
end
