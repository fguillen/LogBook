require_relative "test_helper"

class LogBookTest < MiniTest::Test
  def setup
    LogBook::Event.destroy_all
    User.destroy_all
    Item.destroy_all

    @user = User.create!(:name => "User Name")
    @item = Item.create!(:title => "Item Title", :log_book_historian => @user)
  end

  def test_event
    assert_difference "LogBook::Event.count", 1 do
      LogBook.event(@user, @item, "Item wadus", LogBook::OPERATIONS[:create])
    end

    log_book = LogBook::Event.last
    assert_equal(@user, log_book.historian)
    assert_equal(@item, log_book.historizable)
    assert_equal("Item wadus", log_book.text)
    assert_equal(["user", "item", "create"].sort, log_book.tag_list.sort)
  end

  def test_event_with_nils
    assert_difference "LogBook::Event.count", 1 do
      LogBook.event(nil, nil, "Item wadus", nil)
    end

    log_book = LogBook::Event.last
    assert_nil(log_book.historian)
    assert_nil(log_book.historizable)
    assert_equal("Item wadus", log_book.text)
    assert_equal([], log_book.tag_list)
  end

  def test_created
    item = Item.new(:title => "Item Title")
    item.log_book_historian = @user

    LogBook.expects(:event).with(@user, item, "Item created", LogBook::OPERATIONS[:create])

    item.save!
  end

  def test_created_when_muted
    item = Item.new(:title => "Item Title")
    item.log_book_mute = true

    LogBook.expects(:event).never

    item.save!
  end

  def test_updated
    LogBook.expects(:event).with(@user, @item, "Item updated [title[Item Title -> Other Title]]", LogBook::OPERATIONS[:update])

    @item.update_attributes!(:title => "Other Title")
  end

  def test_updated_when_muted
    LogBook.expects(:event).never

    @item.log_book_mute = true
    @item.update_attributes!(:title => "Other Title")
  end

  def test_item_destroyed
    LogBook.expects(:event).with(@user, @item, "Item destroyed", LogBook::OPERATIONS[:destroy])

    @item.destroy
  end

  def test_item_destroyed_when_muted
    LogBook.expects(:event).never

    @item.log_book_mute = true
    @item.destroy
  end

  def test_has_many_log_book_events
    LogBook::Event.destroy_all

    log_book_event_1 = LogBook.event(@user, @item, "Item wadus", LogBook::OPERATIONS[:create])
    log_book_event_2 = LogBook.event(@user, @item, "Item wadus", LogBook::OPERATIONS[:update])

    @item.reload

    assert_equal(2, @item.log_book_events.count)
    assert_equal(log_book_event_1, @item.log_book_events.first)
    assert_equal(log_book_event_2, @item.log_book_events.last)
  end

  def test_log_book_events_nullify_on_historizable_destroy
    log_book_event = LogBook.event(@user, @item, "Item wadus", LogBook::OPERATIONS[:create])

    @item.destroy

    log_book_event.reload

    assert_equal(true, log_book_event.historizable_id.nil?)
    assert_equal(true, log_book_event.historizable.nil?)
    assert_equal("Item", log_book_event.historizable_type)
  end

  def test_log_book_events_destroy_on_historizable_destroy
    item_with_opts = ItemWithOpts.new
    log_book_event = LogBook.event(@user, item_with_opts, "Item wadus", LogBook::OPERATIONS[:create])

    item_with_opts.destroy

    assert_equal(false, LogBook::Event.exists?(log_book_event.id))
  end
end

