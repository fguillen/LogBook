module HistoryEvent::LogBook
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def history_event_log_book
      after_create :history_event_log_book_on_create
      after_update :history_event_log_book_on_update
      after_destroy :history_event_log_book_on_destroy

      attr_accessor :last_event_historian
    end
  end

  module InstanceMethods
    def history_event_log_book_on_create
      HistoryEvent.created(self.last_event_historian, self)
    end

    def history_event_log_book_on_update
      HistoryEvent.updated(self.last_event_historian, self)
    end

    def history_event_log_book_on_destroy
      HistoryEvent.destroyed(self.last_event_historian, self)
    end

    def pretty_changes
      result =
        self.previous_changes.reject { |k,v| k == "updated_at" || k =~ /password/ || k == "perishable_token" || k == "persistence_token" }.map do |k,v|
          old_value = v[0]
          new_value = v[1]

          old_value = old_value.to_s( :localdb ) if old_value.instance_of? ActiveSupport::TimeWithZone
          new_value = new_value.to_s( :localdb ) if new_value.instance_of? ActiveSupport::TimeWithZone

          "#{k}[#{old_value} -> #{new_value}]"
        end.join( ", " )

      result
    end
  end
end