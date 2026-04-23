# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CombinedIcon do
  describe 'Validations' do
    context 'when all attributes are valid' do
      let(:combined_icon) { build(:combined_icon) }

      it 'is valid' do
        expect(combined_icon).to be_valid
      end
    end
  end

  describe 'Custom Validations' do
    context 'when the image has a disallowed MIME type' do
      let(:combined_icon) { build(:combined_icon, :disallowed_content_type) }

      it 'is invalid' do
        expect(combined_icon).not_to be_valid
        expect(combined_icon.errors[:image]).to include('image/gif は許可されていない形式です')
      end
    end

    context 'when the count is within the limit' do
      let(:original_icon) { build(:original_icon) }
      let(:combined_icon) { create(:combined_icon, original_icon: original_icon) }
      let(:limit) { CombinedIcon::MAX_COMBINED_ICONS_COUNT }

      before do
        create_list(:combined_icon, limit - 1, original_icon: original_icon)
      end

      it 'is valid' do
        expect(combined_icon).to be_valid
      end
    end

    context 'when the count exceeds the limit' do
      let(:original_icon) { build(:original_icon) }
      let(:combined_icon) { build(:combined_icon, original_icon: original_icon) }
      let(:limit) { CombinedIcon::MAX_COMBINED_ICONS_COUNT }

      before do
        create_list(:combined_icon, limit, original_icon: original_icon)
      end

      it 'is invalid' do
        expect(combined_icon).not_to be_valid
        expect(combined_icon.errors[:base]).to include("合成アイコンを保存できるのは、1つの元アイコンごとに#{CombinedIcon::MAX_COMBINED_ICONS_COUNT}個までです")
      end
    end
  end

  context 'when the file size is within the limit' do
    let(:combined_icon) { build(:combined_icon, :within_size_limit) }

    it 'is valid' do
      expect(combined_icon).to be_valid
    end
  end

  context 'when the file size exceeds the limit' do
    let(:combined_icon) { build(:combined_icon, :exceeds_size_limit) }

    it 'is invalid' do
      expect(combined_icon).not_to be_valid
      expect(combined_icon.errors[:image]).to include("申し訳ありません、合成アイコンがサイズ制限を超えてしまっています。\n合成アイコンは#{CombinedIcon::MAX_FILE_SIZE}MB以下のファイルでお願いします。")
    end
  end
end
