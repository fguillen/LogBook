require "active_record"
require "acts-as-taggable-on"
require_relative "log_book/version"
require_relative "log_book/plugin"
require_relative "log_book/utils"

module LogBook
  OPERATIONS = {
    :create => "create",
    :update => "update",
    :destroy => "destroy"
  }

  def self.event(historian, historizable, text, tag_list)
    tag_list_composed = []
    tag_list_composed << scope_tag(historian)   if historian
    tag_list_composed << kind_tag(historizable) if historizable
    tag_list_composed += [tag_list].flatten     if tag_list

    LogBook::Event.create!(
      :historian => historian,
      :historizable => historizable,
      :text => text,
      :tag_list => tag_list_composed
    )
  end

  private

  def self.created(historian, historizable)
    LogBook.event(historian, historizable, "#{historizable.class.name} created", LogBook::OPERATIONS[:create])
  end

  def self.updated(historian, historizable)
    LogBook.event(historian, historizable, "#{historizable.class.name} updated [#{LogBook::Utils.pretty_changes(historizable)}]", LogBook::OPERATIONS[:update])
  end

  def self.destroyed(historian, historizable)
    LogBook.event(historian, historizable, "#{historizable.class.name} destroyed", LogBook::OPERATIONS[:destroy])
  end

  def self.scope_tag(historian)
    historian.class.name.underscore
  end

  def self.kind_tag(historizable)
    historizable.class.name.underscore
  end
end

