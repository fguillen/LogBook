require "active_record"
require "active_support/core_ext/module"
require_relative "log_book/version"
require_relative "log_book/plugin"
require_relative "log_book/utils"

module LogBook
  def self.event(historian, historizable, differences = nil)
    LogBook::Event.create!(
      historian: historian,
      historizable: historizable,
      differences: differences
    )
  end

  private

  def self.created(historian, historizable)
    LogBook.event(historian, historizable)
  end

  def self.updated(historian, historizable)
    LogBook.event(historian, historizable, LogBook::Utils.pretty_changes(historizable))
  end

  def self.destroyed(historian, historizable)
    LogBook.event(historian, historizable)
  end
end

