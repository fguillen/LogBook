require "active_record"
require "acts-as-taggable-on"
require_relative "history_event/version"
require_relative "history_event/model"
require_relative "history_event/log_book"


module HistoryEvent
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

    HistoryEvent::Model.create!(
      :historian => historian,
      :historizable => historizable,
      :text => text,
      :tag_list => tag_list_composed
    )
  end

  def self.created(historian, historizable)
    HistoryEvent.event(historian, historizable, "#{historizable.class.name} created", HistoryEvent::OPERATIONS[:create])
  end

  def self.updated(historian, historizable)
    HistoryEvent.event(historian, historizable, "#{historizable.class.name} updated [#{historizable.pretty_changes}]", HistoryEvent::OPERATIONS[:update])
  end

  def self.destroyed(historian, historizable)
    HistoryEvent.event(historian, historizable, "#{historizable.class.name} destroyed", HistoryEvent::OPERATIONS[:destroy])
  end

  private

  def self.scope_tag(historian)
    historian.class.name.underscore
  end

  def self.kind_tag(historizable)
    historizable.class.name.underscore
  end
end

ActiveSupport.on_load(:active_record) do
  include HistoryEvent::LogBook
end

