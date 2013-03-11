module LogBook::Plugin
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def log_book
      after_create :log_book_event_on_create
      after_update :log_book_event_on_update
      after_destroy :log_book_event_on_destroy

      attr_accessor :log_book_historian
    end
  end

  module InstanceMethods
    def log_book_event_on_create
      LogBook.created(self.log_book_historian, self)
    end

    def log_book_event_on_update
      LogBook.updated(self.log_book_historian, self)
    end

    def log_book_event_on_destroy
      LogBook.destroyed(self.log_book_historian, self)
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

ActiveSupport.on_load(:active_record) do
  include LogBook::Plugin
end