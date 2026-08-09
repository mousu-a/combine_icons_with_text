# frozen_string_literal: true

module LoginSupport
  module System
    def login(user, name: user.name)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: user.provider,
        uid: user.uid,
        info: { name:, image: user.avatar_url }
      )
      visit welcome_path
      click_on 'Googleアカウントでログイン'

      expect(page).to have_text 'ログインしました'
    end
  end

  module Request
    def login(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: user.provider,
        uid: user.uid,
        info: { name: user.name, image: user.avatar_url }
      )
      get "/auth/#{user.provider}/callback"
    end
  end
end
