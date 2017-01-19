class User < ActiveRecord::Base
end

class Item < ActiveRecord::Base
  log_book
end

class ItemWithOpts < Item
  log_book(:dependent => :destroy, :ignore => [:my_counter])
end