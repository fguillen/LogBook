class CreateLogBookEvents < ActiveRecord::Migration[4.2]
  def self.up
    create_table :log_book_events do |t|
      t.integer :historian_id
      t.string :historian_type
      t.integer :historizable_id
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
