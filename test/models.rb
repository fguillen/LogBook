class User < ActiveRecord::Base
end

class Item < ActiveRecord::Base
  history_event_log_book
end