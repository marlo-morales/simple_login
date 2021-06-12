# frozen_string_literal: true

class AccessLock
  DEFAULT_ACCESS_FAILED_MAX_COUNT = 5

  attr_accessor :resource

  def initialize(resource:, access_failed_max_count: nil)
    @resource = resource
    @access_failed_max_count = access_failed_max_count
  end

  def access_failed!
    @resource.increment!(:access_failed_count)
  end

  def lock_access!
    return unless access_locked?

    @resource.update(access_locked_at: Time.current)
    @resource.errors.add(:base, I18n.t('errors.messages.access_locked'))
  end

  def access_locked?
    !@resource&.access_locked_at.blank? || @resource&.access_failed_count.to_i >= access_failed_max_count
  end

  def unlock_access!
    @resource.update(access_failed_count: 0, access_locked_at: nil)
  end

  def access_failed_max_count
    @access_failed_max_count ||= DEFAULT_ACCESS_FAILED_MAX_COUNT
  end
end
