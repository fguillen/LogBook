require "rails/generators"

class LogBook::MigrationGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  desc "Generates migration for LogBook::Event model"

  def self.source_root
    File.join(File.dirname(__FILE__), "templates")
  end

  def self.next_migration_number(dirname) #:nodoc:
    migration_number_attempt = Time.now.utc.strftime("%Y%m%d%H%M%S")

    if ActiveRecord::Base.timestamped_migrations && migration_number_attempt > current_migration_number(dirname).to_s
      migration_number_attempt
    else
      serial_migration_number(dirname)
    end
  end

  def copy_migration
    migration_template "create_log_book_events.rb", "db/migrate/create_log_book_events.rb"
  end
end