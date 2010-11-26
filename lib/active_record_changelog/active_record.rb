module ActiveRecordChangelog
  module ActiveRecord
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def log_changes(options = {})
        send :include, InstanceMethods

        cattr_accessor :ignore
        self.ignore = options[:ignore] || []

        self.class_eval do
          has_many :changelogs, :as => :item

          around_update :changelog_around_update
        end
      end
    end

    module InstanceMethods
      def changelog_around_update
        changelog_get_changes
        yield
        changelog_log_changes
      end

      def changelog_get_changes
        @__changelog_changes = self.changes
      end

      def changelog_log_changes
        return if @__changelog_changes.empty? || !self.persisted?

        self.ignore.each do |attr|
          @__changelog_changes.delete attr
        end

        fields_changed = []
        summary = ""
        @__changelog_changes.each do |column,values|
          fields_changed << column
          summary << "#{column}:<br />"
          summary << "from: <pre>#{values[0]}</pre>"
          summary << "to: <pre>#{values[1]}</pre>"
          summary << "<hr />"
        end

        self.changelogs.create!(
          :fields_changed => fields_changed.join(','),
          :summary => summary,
          :changer => ''
        )
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecordChangelog::ActiveRecord
