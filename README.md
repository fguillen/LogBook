# HistoryEvent

Storing an events log book.

## Installation

Add this line to your application's Gemfile:

    gem "history_event"

## Usage

In any point:

    HistoryEvent.event(<who executes the action>, <over which object>, <text>, <list of tags>)

For example:

    HistoryEvent.event(current_user, item, "Item canceled", [:purchase, :canceled])

## ActiveRecord integration

    class MyModel < ActiveRecord::Base
      history_event_log_book
    end

    my_model = MyModel.create!  # => HistoryEvent created
    my_model = MyModel.save!    # => HistoryEvent created
    my_model = MyModel.destroy! # => HistoryEvent created

If you want to include _who executes the action_ use the special attribute `last_event_historian`:

    my_model.last_event_historian = current_user
    my_model = MyModel.save!

## Sate of the art

Beta version but already used in production environments
