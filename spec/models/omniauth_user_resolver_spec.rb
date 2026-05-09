# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniAuthUserResolver do
  describe '.find_or_create_user' do
    context 'when the user already exists' do
      let!(:user) { create(:user) }
      let(:auth_hash) { auth_hash_for(uid: user.uid, provider: user.provider) }
      let(:find_or_create_user) { described_class.new(auth_hash).find_or_create_user }

      it 'finds the user without creating a new one' do
        expect { find_or_create_user }.not_to change(User, :count)
        expect(find_or_create_user).to eq user
      end
    end

    context 'when the user does not exist' do
      let(:auth_hash) { auth_hash_for(uid: 'New1234', provider: 'google_oauth2') }
      let(:find_or_create_user) { described_class.new(auth_hash).find_or_create_user }

      it 'creates a new user' do
        expect { find_or_create_user }.to change(User, :count).by(1)
        expect(find_or_create_user).to be_persisted
      end
    end
  end

  def auth_hash_for(uid:, provider:)
    OmniAuth::AuthHash.new(
      info: {
        name: 'test_user',
        image: 'https://example.com/test_user.jpg'
      },
      uid: uid,
      provider: provider
    )
  end
end
