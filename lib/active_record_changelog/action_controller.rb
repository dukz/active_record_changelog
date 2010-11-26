module ActiveRecordChangelog
  module ActionController
    def self.included(base)
      base.before_filter :set_active_record_changer
    end

    protected

    def set_active_record_changer
      ::ActiveRecordChangelog.changer = (current_user ? current_user.id : "" )
    end
  end
end

ActionController::Base.send :include, ActiveRecordChangelog::ActionController
