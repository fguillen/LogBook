require_relative "test_helper"

class HistoryEventTest < MiniTest::Unit::TestCase
  def setup
    HistoryEvent::Model.destroy_all
    User.destroy_all
    Item.destroy_all

    @user = User.create!(:name => "User Name")
    @item = Item.create!(:title => "Item Title")
  end

  def test_event
    assert_difference "HistoryEvent::Model.count", 1 do
      HistoryEvent.event(@user, @item, "Item wadus", HistoryEvent::OPERATIONS[:create])
    end

    history_event = HistoryEvent::Model.last
    assert_equal(@user, history_event.historian)
    assert_equal(@item, history_event.historizable)
    assert_equal("Item wadus", history_event.text)
    assert_equal(["user", "item", "create"].sort, history_event.tag_list.sort)
  end

  def test_event_with_nils
    assert_difference "HistoryEvent::Model.count", 1 do
      HistoryEvent.event(nil, nil, "Item wadus", nil)
    end

    history_event = HistoryEvent::Model.last
    assert_equal(nil, history_event.historian)
    assert_equal(nil, history_event.historizable)
    assert_equal("Item wadus", history_event.text)
    assert_equal([], history_event.tag_list)
  end

  def test_created
    HistoryEvent.expects(:event).with("historian", @item, "Item created", HistoryEvent::OPERATIONS[:create])
    HistoryEvent.created("historian", @item)
  end

  def test_updated
    @item.update_attributes!(:title => "Other Title")

    HistoryEvent.expects(:event).with(@user, @item, "Item updated [title[Item Title -> Other Title]]", HistoryEvent::OPERATIONS[:update])
    HistoryEvent.updated(@user, @item)
  end

  def test_item_destroyed
    HistoryEvent.expects(:event).with(@user, @item, "Item destroyed", HistoryEvent::OPERATIONS[:destroy])
    HistoryEvent.destroyed(@user, @item)
  end
end

