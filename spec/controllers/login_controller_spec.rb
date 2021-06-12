# frozen_string_literal: true

require 'rails_helper'

describe LoginController, type: :controller do
  include ApplicationHelper

  let(:user) { create(:user) }
  let(:password) { attributes_for(:user)[:password] }

  describe '#new' do
    it 'renders login page' do
      get :new
      expect(response).to have_http_status :ok
    end
  end

  describe '#create' do
    let(:params) { { username: user.username, password: password } }

    before { post :create, params: params }

    it 'logs in successfully' do
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq I18n.t('success.messages.login')
    end

    context 'for failed login' do
      context 'when username not found' do
        let(:params) { { username: user.username + 'X', password: password } }
        let(:errors) { [I18n.t('errors.messages.not_found', key: 'Username')] }

        it 'does not successfully logged in' do
          expect(response).to render_template :new
          expect(flash.now[:alert]).to eq format_flash_errors(errors)
        end
      end

      context 'when password is invalid' do
        let(:params) { { username: user.username, password: password + 'X' } }
        let(:errors) { [I18n.t('errors.messages.invalid_secret', secret: :password)] }

        it 'does not successfully logged in' do
          expect(response).to render_template :new
          expect(flash.now[:alert]).to eq format_flash_errors(errors)
          expect(user.reload.access_failed_count).to eq 1
        end
      end

      context 'when maximum login attempts reached' do
        let(:params) { { username: user.username, password: password + 'X' } }
        let(:errors) { [I18n.t('errors.messages.access_locked')] }
        let(:access_failed_max_count) { user.class::ACCESS_FAILED_MAX_COUNT }

        before { post :create, params: params }

        it 'locks the user access' do
          Timecop.freeze do
            current_time = Time.current
            post :create, params: params
            expect(response).to render_template :new
            expect(flash.now[:alert]).to include format_flash_errors(errors)
            expect(user.reload.access_failed_count).to eq access_failed_max_count
            expect(user.access_locked_at.utc).to eq current_time.utc
          end
        end
      end
    end 
  end

  describe '#destroy' do
    it 'logs out successfully' do
      delete :destroy
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq I18n.t('success.messages.logout')
    end
  end
end