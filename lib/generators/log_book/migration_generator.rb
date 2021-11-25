require "rails/generators"

module LogBook::GeneratorUtils
  def source_root
    File.join(File.dirname(__FILE__), "templates")
  end

  def next_migration_number(dirname) #:nodoc:
    migration_number_attempt = Time.now.utc.strftime("%Y%m%d%H%M%S")

    if ActiveRecord::Base.timestamped_migrations && migration_number_attempt > current_migration_number(dirname).to_s
      migration_number_attempt
    else
      serial_migration_number(dirname)
    end
  end
end

class LogBook::MigrationGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend LogBook::GeneratorUtils

  desc "Generates migration for LogBook::Event model with support for UUIDs instead of IDs"

  def copy_migration
    migration_template "create_log_book_events_uuids_support.rb", "db/migrate/create_log_book_events.rb"
  end
end


# class LogBook::MigrationGenerator < Rails::Generators::Base
#   include Rails::Generators::Migration
#   extend LogBook::GeneratorUtils



#   desc "Generates migration for LogBook::Event model"

#   def copy_migration
#     migration_template "create_log_book_events.rb", "db/migrate/create_log_book_events_uuids_support.rb"
#   end
# end
