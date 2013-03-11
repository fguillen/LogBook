ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :items, :force => true do |t|
    t.string :title
  end

  # acts-as-taggable-on
  # https://github.com/mbleigh/acts-as-taggable-on/blob/master/lib/generators/acts_as_taggable_on/migration/templates/active_record/migration.rb
  create_table :tags do |t|
    t.string :name
  end

  create_table :taggings do |t|
    t.references :tag
    t.references :taggable, :polymorphic => true
    t.references :tagger, :polymorphic => true
    t.string :context, :limit => 128

    t.datetime :created_at
  end
end