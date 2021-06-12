# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  subject { build_stubbed(:user) }

  context 'validations' do
    context 'for username' do
      let(:attribute) { 'Username ' }

      context 'when blank' do
        let(:error_message) { attribute + I18n.t('errors.messages.blank') }

        it 'does not create the user' do
          subject.username = nil
          is_expected.to be_invalid
          expect(subject.errors.full_messages).to include error_message
        end
      end

      context 'when duplicate exists' do
        subject { build_stubbed(:user, username: duplicate_username) }

        let(:duplicate_username) { 'duplicado' }
        let(:existing_user) { build(:user, username: duplicate_username) }
        let(:error_message) { attribute + I18n.t('errors.messages.taken') }

        it 'does not create the user' do
          expect(existing_user.save).to be_truthy
          is_expected.to be_invalid
          expect(subject.errors.full_messages).to include error_message
        end
      end

      context 'when it is too short' do
        let(:error_message) { attribute + I18n.t('errors.messages.too_short', count: User::USERNAME_MIN_LENGTH) }

        it 'does not create the user' do
          subject.username = 'u'
          is_expected.to be_invalid
          expect(subject.errors.full_messages).to include error_message
        end
      end
    end

    context 'for password' do
      let(:attribute) { 'Password ' }

      context 'when blank' do
        subject { build(:user) }

        let(:error_message) { attribute + I18n.t('errors.messages.blank') }

        it 'does not create the user' do
          subject.password = nil
          subject.save
          is_expected.to be_invalid
          expect(subject.errors.full_messages).to include error_message
        end
      end

      context 'when it is too short' do
        let(:error_message) { attribute + I18n.t('errors.messages.too_short', count: User::PASSWORD_MIN_LENGTH) }

        it 'does not create the user' do
          subject.password = 'Pass12'
          is_expected.to be_invalid
          expect(subject.errors.full_messages).to include error_message
        end
      end
    end
  end
end
