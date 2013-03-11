require "minitest/unit"
require "minitest/autorun"
require "mocha/setup"
require "assert_difference"
require "active_record"
require "acts-as-taggable-on"

FileUtils.rm("#{File.dirname(__FILE__)}/db/history_event.sqlite", :force => true)

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "#{File.dirname(__FILE__)}/db/history_event.sqlite"
)

require_relative "../lib/generators/history_event/templates/create_history_events"
CreateHistoryEvents.up

require_relative "../lib/history_event"

load("#{File.dirname(__FILE__)}/schema.rb")
load("#{File.dirname(__FILE__)}/models.rb")

class MiniTest::Unit::TestCase
  include AssertDifference
  FIXTURES = File.expand_path("#{File.dirname(__FILE__)}/fixtures")
end

