class CreateLogBookEventsUuidsSupport < ActiveRecord::Migration[4.2]
  def self.up
    create_table :log_book_events do |t|
      t.string :historian_id, limit: 36
      t.string :historian_type
      t.string :historizable_id, limit: 36
      t.string :historizable_type
      t.text :differences, :limit => 16777215 # mediumtext

      t.timestamps :null => false
    end

    add_index :log_book_events, [:historizable_id, :historizable_type, :created_at], :name => "index_log_book_events_on_historizable_and_created_at"
    add_index :log_book_events, [:created_at]
  end

  def self.down
    drop_table :log_book_events
  end
end
