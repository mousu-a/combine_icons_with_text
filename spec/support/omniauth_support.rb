# frozen_string_literal: true

module OmniAuthSupport
  def auth_hash_for(uid:, provider:, name: 'test_user', image: 'https://example.com/test_user.jpg')
    OmniAuth::AuthHash.new(
      provider: provider,
      uid: uid,
      info: { name: name, image: image }
    )
  end
end
