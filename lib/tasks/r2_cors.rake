# frozen_string_literal: true

namespace :r2 do
  desc 'R2にCORS設定を適用する（本番ドメインからの画像GETを許可する でないとR2経由の既存アイコン合成機能が使えないため）'
  task configure_cors: :environment do
    r2_credentials = Rails.application.credentials[:r2]
    bucket = r2_credentials.fetch(:bucket)
    client = r2_client(r2_credentials)

    client.put_bucket_cors(bucket: bucket, cors_configuration: r2_cors_configuration)

    puts 'CORS設定を適用した 現在の設定:'
    puts client.get_bucket_cors(bucket: bucket).cors_rules
  end
end

def r2_client(r2_credentials)
  Aws::S3::Client.new(
    access_key_id: r2_credentials.fetch(:access_key_id),
    secret_access_key: r2_credentials.fetch(:secret_access_key),
    endpoint: r2_credentials.fetch(:endpoint),
    region: 'auto',
    force_path_style: true
  )
end

def r2_cors_configuration
  {
    cors_rules: [
      {
        allowed_origins: ['https://icon-font-mashup.com'],
        allowed_methods: ['GET'],
        allowed_headers: [],
        max_age_seconds: 3000
      }
    ]
  }
end
