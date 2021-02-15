class LogBook::Event < ::ActiveRecord::Base
  self.table_name = "log_book_events"

  belongs_to :historian, polymorphic: true, optional: true
  belongs_to :historizable, polymorphic: true

  scope :by_recent, -> { order("id desc") }

  serialize :differences, JSON

  def kind
    return :update if differences.present?

    historizable.present? ? :create : :destroy
  end
end
