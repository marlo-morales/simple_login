# frozen_string_literal: true

class LoginController < ApplicationController
  before_action :only_for_anonymous, except: :destroy

  def new; end

  def create
    if authentication.valid?
      session[:user_id] = authentication.resource.id
      access.unlock_access!
      redirect_to root_path, notice: I18n.t('success.messages.login')
    else
      process_access!
      flash.now[:alert] = alert_message
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: I18n.t('success.messages.logout')
  end

  private

  def only_for_anonymous
    redirect_to root_path if session[:user_id]
  end

  def allowed_params
    params.permit(:username, :password)
  end

  def authentication
    @authentication ||= Authentication.new(params: allowed_params)
  end

  def access
    @access ||= AccessLock.new(resource: authentication.resource, access_failed_max_count: User::ACCESS_FAILED_MAX_COUNT)
  end

  def process_access!
    return if authentication.errors[:invalid_secret].blank?

    access.access_failed!
    access.lock_access!
  end

  def alert_message
    errors =
      if access.access_locked?
        access.resource.errors.full_messages
      else
        authentication.errors.values
      end
    format_flash_errors(errors)
  end
end
