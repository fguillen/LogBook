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
  end

  def self.down
    drop_table :log_book_events
  end
end
