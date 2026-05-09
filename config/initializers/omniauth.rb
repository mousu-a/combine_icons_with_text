# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'], { prompt: 'consent' }
  on_failure { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
end
