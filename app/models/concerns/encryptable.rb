# frozen_string_literal: true

module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    def encrypted(*attributes)
      attributes.each do |attribute|
        if available_attributes.include?(attribute.to_s)
          define_method "#{attribute}=" do |value|
            plain_text!(attribute.to_s, value)

            super(value.blank? ? value : Cipher.new(value).encrypt)
          end
        else
          raise "Encryption failed. Cannot find attribute: #{attribute}"
        end
      end
    end

    private

    def available_attributes
      column_names + stored_attributes.values.flatten.map(&:to_s).compact
    end
  end

  def available_attribute(attribute)
    self[attribute.to_s] || send(attribute)
  end

  def plain_text!(attribute, value)
    return unless respond_to?("plain_text_#{attribute}")

    send("plain_text_#{attribute}=", value)
  end
end
