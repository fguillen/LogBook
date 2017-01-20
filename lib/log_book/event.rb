class LogBook::Event < ::ActiveRecord::Base
  self.table_name = "log_book_events"

  attr_accessible :historian, :historizable, :differences, :tag_list

  acts_as_taggable

  belongs_to :historian, :polymorphic => true
  belongs_to :historizable, :polymorphic => true

  scope :by_recent, -> { order("id desc") }

  serialize :differences, JSON
end
