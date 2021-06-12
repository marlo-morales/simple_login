# frozen_string_literal: true

class Cipher
  def initialize(plain_text)
    @plain_text = plain_text
    @key_salt = generate_hash(Rails.application.secret_key_base + ENV['CIPHER_SALT'])
  end

  def encrypt
    generate_hash(@key_salt + @plain_text)
  end

  private

  def generate_hash(text)
    Digest::SHA256.hexdigest(text)
  end
end
