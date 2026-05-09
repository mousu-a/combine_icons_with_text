# frozen_string_literal: true

module LoginSupport
  def sign_in_with_google(user, name: user.name)
    OmniAuth.configure do |config|
      config.test_mode = true
      config.mock_auth[:google_oauth2] =
        OmniAuth::AuthHash.new({
                                 provider: user.provider,
                                 uid: user.uid,
                                 info: { name: }
                               })
    end
    visit welcome_path
    click_on 'Googleアカウントでログイン'

    expect(page).to have_content 'ログインしました'
  end
end
