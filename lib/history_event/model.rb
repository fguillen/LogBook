class HistoryEvent::Model < ::ActiveRecord::Base
  self.table_name = "history_events"

  attr_accessible :historian, :historizable, :text, :tag_list

  acts_as_taggable

  belongs_to :historian, :polymorphic => true
  belongs_to :historizable, :polymorphic => true

  validates :text, :presence => true
end
