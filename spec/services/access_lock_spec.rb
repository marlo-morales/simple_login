# frozen_string_literal: true

require 'rails_helper'

describe AccessLock do
  subject { described_class.new(resource: resource, access_failed_max_count: resource.class::ACCESS_FAILED_MAX_COUNT) }

  let(:resource) { build(:user) }

  describe '#access_failed!' do
    it 'increments the access_failed_count attribute' do
      expect(resource.access_failed_count).to eq 0
      subject.access_failed!
      expect(resource.access_failed_count).to eq 1
    end
  end

  describe '#lock_access!' do
    it 'updates the access_locked_at attribute to current time' do
      expect(resource.access_locked_at).to be_nil
      subject.access_failed_max_count.times { subject.access_failed! }
      Timecop.freeze do
        subject.lock_access!
        expect(resource.access_locked_at).to eq Time.current
        expect(resource.errors.full_messages).to include I18n.t('errors.messages.access_locked')
      end
    end
  end

  describe '#access_locked?' do
    it 'asserts truthy' do
      subject.access_failed_max_count.times { subject.access_failed! }
      subject.lock_access!
      expect(subject.access_locked?).to be_truthy
    end

    it 'asserts falsy' do
      expect(subject.access_locked?).to be_falsy
    end
  end

  describe '#unlock_access!' do
    it 'unlocks the access' do
      subject.access_failed_max_count.times { subject.access_failed! }
      subject.lock_access!
      expect(subject.access_locked?).to be_truthy
      subject.unlock_access!
      expect(subject.access_locked?).to be_falsy
    end
  end
end