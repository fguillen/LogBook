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
      cattr_accessor :log_book_options

      self.log_book_options = opts
      self.log_book_options[:ignore] ||= []
      self.log_book_options[:ignore] << :updated_at # ignoring noisy field
    end
  end

  module InstanceMethods
    def log_book_event_on_create
      LogBook.created(self.log_book_historian, self) if !self.log_book_mute
    end

    def log_book_event_on_update
      # TODO: this line of code is duplicated
      if ActiveRecord::VERSION::STRING.to_f >= 5.1
        clean_changes = saved_changes.select { |k,v| !self.log_book_options[:ignore].include? k.to_sym }
      else
        clean_changes = changes.select { |k,v| !self.log_book_options[:ignore].include? k.to_sym }
      end
      LogBook.updated(self.log_book_historian, self) if !clean_changes.empty? and !self.log_book_mute
    end

    def log_book_event_on_destroy
      LogBook.destroyed(self.log_book_historian, self) if !self.log_book_mute
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include LogBook::Plugin
end
