# frozen_string_literal: true

class Authentication
  attr_accessor :resource, :errors

  def initialize(params:, model: User, key: :username, secret: :password)
    @resource = model.find_by("#{key}": params[key.to_s])
    @key = key
    @secret = secret
    @encrypted_secret = @resource&.send(secret.to_s)
    @input_secret = params[secret.to_s]
    @errors = {}
  end

  def valid?
    if @resource.blank?
      @errors[:not_found] = I18n.t('errors.messages.not_found', key: @key.to_s.titleize)
    elsif @encrypted_secret != encrypted_input_secret
      @errors[:invalid_secret] = I18n.t('errors.messages.invalid_secret', secret: @secret)
    end
    @errors.blank?
  end

  private

  def encrypted_input_secret
    Cipher.new(@input_secret).encrypt
  end
end
