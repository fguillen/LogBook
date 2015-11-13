ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :items, :force => true do |t|
    t.string :title
  end

  # acts-as-taggable-on
  # https://github.com/mbleigh/acts-as-taggable-on/blob/6e1837762f0d60edc9b6c2d92b5a9435f404173f/spec/internal/db/schema.rb
  create_table :tags, force: true do |t|
    t.string :name
    t.integer :taggings_count, default: 0
    t.string :type
  end
  add_index 'tags', ['name'], name: 'index_tags_on_name', unique: true

  create_table :taggings, force: true do |t|
    t.references :tag
    t.references :taggable, polymorphic: true
    t.references :tagger, polymorphic: true
    t.string :context, limit: 128

    t.datetime :created_at
  end
  add_index 'taggings',
            ['tag_id', 'taggable_id', 'taggable_type', 'context', 'tagger_id', 'tagger_type'],
            unique: true, name: 'taggings_idx'
end