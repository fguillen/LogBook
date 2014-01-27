require "active_record"
require "active_support/core_ext/module"
require "assert_difference"
require "acts-as-taggable-on"
require "minitest/autorun"
require "mocha/setup"
require_relative "../lib/log_book"

FileUtils.rm("#{File.dirname(__FILE__)}/db/log_book.sqlite", :force => true)

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "#{File.dirname(__FILE__)}/db/log_book.sqlite"
)

require_relative "../lib/log_book/event"

require_relative "../lib/generators/log_book/templates/create_log_book_events"
CreateLogBookEvents.up

load("#{File.dirname(__FILE__)}/schema.rb")
load("#{File.dirname(__FILE__)}/models.rb")

class MiniTest::Unit::TestCase
  include AssertDifference
  FIXTURES = File.expand_path("#{File.dirname(__FILE__)}/fixtures")
end

