require_relative "test_helper"

class LogBookTest < MiniTest::Unit::TestCase
  def setup
    LogBook::Event.destroy_all
    User.destroy_all
    Item.destroy_all

    @user = User.create!(:name => "User Name")
    @item = Item.create!(:title => "Item Title")
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
    assert_equal(nil, log_book.historian)
    assert_equal(nil, log_book.historizable)
    assert_equal("Item wadus", log_book.text)
    assert_equal([], log_book.tag_list)
  end

  def test_created
    LogBook.expects(:event).with("historian", @item, "Item created", LogBook::OPERATIONS[:create])
    LogBook.created("historian", @item)
  end

  def test_updated
    @item.update_attributes!(:title => "Other Title")

    LogBook.expects(:event).with(@user, @item, "Item updated [title[Item Title -> Other Title]]", LogBook::OPERATIONS[:update])
    LogBook.updated(@user, @item)
  end

  def test_item_destroyed
    LogBook.expects(:event).with(@user, @item, "Item destroyed", LogBook::OPERATIONS[:destroy])
    LogBook.destroyed(@user, @item)
  end
end

