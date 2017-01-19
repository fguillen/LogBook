module LogBook::Plugin
  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def log_book(opts = {})
      after_create :log_book_event_on_create
      after_update :log_book_event_on_update
      before_destroy :log_book_event_on_destroy

      has_many :log_book_events, :class_name => "LogBook::Event", :as => :historizable, :dependent => (opts[:dependent] || :nullify)

      attr_accessor :log_book_historian
      attr_accessor :log_book_mute
    end
  end

  module InstanceMethods
    def log_book_event_on_create
      LogBook.created(self.log_book_historian, self) if !self.log_book_mute
    end

    def log_book_event_on_update
      LogBook.updated(self.log_book_historian, self) if !changes.empty? and !self.log_book_mute
    end

    def log_book_event_on_destroy
      LogBook.destroyed(self.log_book_historian, self) if !self.log_book_mute
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include LogBook::Plugin
end