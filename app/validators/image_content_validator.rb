# frozen_string_literal: true

class ImageContentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    validate_content_type(record, attribute, value)
    validate_byte_size(record, attribute, value)
  end

  def validate_content_type(record, attribute, value)
    allowed_mime_types = %w[image/jpeg image/png image/webp]
    return if allowed_mime_types.include?(value.blob.content_type)

    record.errors.add(attribute, :invalid_content_type, content_type: value.blob.content_type)
  end

  def validate_byte_size(record, attribute, value)
    max_file_size_mb = options[:max_file_size].megabytes
    return if value.blob.byte_size <= max_file_size_mb

    record.errors.add(attribute, :file_too_large, max_file_size: options[:max_file_size])
  end
end
