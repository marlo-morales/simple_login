# frozen_string_literal: true

class User < ApplicationRecord
  include Encryptable

  USERNAME_MIN_LENGTH = 3
  PASSWORD_MIN_LENGTH = 8
  ACCESS_FAILED_MAX_COUNT = 3

  attr_accessor :plain_text_password

  validates :username, presence: true, uniqueness: true, length: { minimum: USERNAME_MIN_LENGTH }
  validates :password, presence: true, if: :password_check_needed?
  validate :password_length, if: :password_changed?

  encrypted :password

  private

  def password_check_needed?
    new_record? || !password.blank?
  end

  def password_length
    return unless plain_text_password&.length.to_i < PASSWORD_MIN_LENGTH

    errors.add(:password, :too_short, count: PASSWORD_MIN_LENGTH)
  end
end
