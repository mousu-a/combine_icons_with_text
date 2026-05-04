# frozen_string_literal: true

FactoryBot.define do
  factory :original_icon do
    user

    after(:build) do |original_icon, evaluator|
      if evaluator.io
        original_icon.image.attach(
          io: evaluator.io,
          filename: evaluator.filename,
          content_type: evaluator.content_type
        )
      end
    end

    transient do
      io { Rails.root.join('spec/files/dummy_3MB.jpg').open }
      filename { 'sample.jpg' }
      content_type { 'image/jpeg' }
    end

    trait :disallowed_content_type do
      io { StringIO.new('This is an invalid file') }
      filename { 'invalid.txt' }
      content_type { 'text/plain' }
    end

    trait :within_size_limit do
      io { Rails.root.join('spec/files/dummy_5.7MB.jpg').open }
    end

    trait :exceeds_size_limit do
      io { Rails.root.join('spec/files/dummy_6.4MB.jpg').open }
    end
  end
end
