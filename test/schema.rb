ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :items, :force => true do |t|
    t.string :title
    t.integer :my_counter
  end
end
