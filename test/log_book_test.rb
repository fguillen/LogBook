require_relative "test_helper"
require "pry"

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
      LogBook.event(@user, @item, ["DIFFERENCE"])
    end

    log_book_event = LogBook::Event.last
    assert_equal(@user, log_book_event.historian)
    assert_equal(@item, log_book_event.historizable)
    assert_equal(["DIFFERENCE"], log_book_event.differences)
  end

  def test_event_with_nils
    assert_difference "LogBook::Event.count", 1 do
      LogBook.event(nil, nil, ["DIFFERENCE"])
    end

    log_book_event = LogBook::Event.last
    assert_nil(log_book_event.historian)
    assert_nil(log_book_event.historizable)
    assert_equal(["DIFFERENCE"], log_book_event.differences)
  end

  def test_created
    item = Item.new(:title => "Item Title")
    item.log_book_historian = @user
    item.save!

    assert_equal(:create, item.log_book_events.last.kind)
  end

  def test_created_when_muted
    item = Item.new(:title => "Item Title")
    item.log_book_mute = true

    LogBook.expects(:event).never

    item.save!
  end

  def test_updated
    differences = [
      {
        "key" => "title",
        "before" => "Item Title",
        "after" => "Other Title"
      }
    ]
    @item.update_attributes!(:title => "Other Title")

    assert_equal(:update, @item.log_book_events.last.kind)
  end

  def test_updated_when_muted
    LogBook.expects(:event).never

    @item.log_book_mute = true
    @item.update_attributes!(:title => "Other Title")
  end

  def test_updated_with_ignore_fields
    differences = [
      {
        "key" => "title",
        "before" => "Item Title",
        "after" => "Other Title"
      }
    ]

    item_with_opts = ItemWithOpts.create!(:title => "Item Title", :my_counter => 0)
    LogBook.expects(:event).with(@user, item_with_opts, differences)

    item_with_opts.log_book_historian = @user
    item_with_opts.update_attributes!(:title => "Other Title", :my_counter => 10)
  end

  def test_item_destroyed
    LogBook.expects(:event).with(@user, @item, nil)

    @item.destroy

    assert_equal(:destroy, LogBook::Event.last.kind)
  end

  def test_item_destroyed_when_muted
    LogBook.expects(:event).never

    @item.log_book_mute = true
    @item.destroy
  end

  def test_has_many_log_book_events
    LogBook::Event.destroy_all

    log_book_event_1 = LogBook.event(@user, @item, nil)
    log_book_event_2 = LogBook.event(@user, @item, nil)

    @item.reload

    assert_equal(2, @item.log_book_events.count)
    assert_equal(log_book_event_1, @item.log_book_events.first)
    assert_equal(log_book_event_2, @item.log_book_events.last)
  end

  def test_log_book_events_nullify_on_historizable_destroy
    log_book_event = LogBook.event(@user, @item, nil)

    @item.destroy

    log_book_event.reload

    assert_equal(true, log_book_event.historizable_id.nil?)
    assert_equal(true, log_book_event.historizable.nil?)
    assert_equal("Item", log_book_event.historizable_type)
  end

  def test_log_book_events_destroy_on_historizable_destroy
    item_with_opts = ItemWithOpts.new
    log_book_event = LogBook.event(@user, item_with_opts, nil)

    item_with_opts.destroy

    assert_equal(false, LogBook::Event.exists?(log_book_event.id))
  end
end

