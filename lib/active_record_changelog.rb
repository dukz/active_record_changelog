# ActiveRecordChangelog

require 'active_record_changelog/active_record.rb'
require 'active_record_changelog/action_controller.rb'

module ActiveRecordChangelog
  def self.changer
    ar_changelog[:changer]
  end

  def self.changer=(value)
    ar_changelog[:changer] = value
  end

  private

  def self.ar_changelog
    Thread.current[:ar_changelog] ||= {}
  end
end
