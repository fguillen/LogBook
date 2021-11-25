# LogBook

Storing an events log book.

## Installation

Add this line to your application's Gemfile:

    gem "log_book"

As the Model should be loaded after ActiveReccord has established the connection you have to add this:

    # config/application.rb
    config.after_initialize do
      require "log_book/event"
    end

### Create the table

    rails generate log_book:migration
    rake db:migrate

### ActsOnTaggableOn dependency

    rails generate acts_as_taggable_on:migration
    # rake acts_as_taggable_on_engine:install:migrations # for version '~> 4.0' or superior
    rake db:migrate

## Usage

In any point:

    LogBook.event(<who executes the action>, <over which object>, <text>, <list of tags>)

For example:

    LogBook.event(current_user, item, "Item canceled", [:purchase, :canceled])

## ActiveRecord integration

    class MyModel < ActiveRecord::Base
      log_book
    end

    MyModel.create!   # => LogBook created
    my_model.save!    # => LogBook created
    my_model.destroy! # => LogBook created

If you want to include _who executes the action_ use the special attribute `log_book_historian`:

    my_model.log_book_historian = current_user
    my_model.save!

If you want to _mute_ a model change:

    my_model.log_book_mute = true
    my_model.save! # No LogBook::Event will be generated

If you want to _ignore_ some fields from the changes Event:

    class MyModel < ActiveRecord::Base
      log_book :ignore => [:my_counter]
    end

    my_model.update_atttibtes!(:my_counter => 9) # No LogBook::Event will be generated

If you want _LogBook::Events_ to be destroyed on _Model_ destroy:

    class MyModel < ActiveRecord::Base
      log_book :dependent => :destroy
    end

In other case the _LogBook::Events_ will remain after _Model_ destroyed.

## Rails Integration

Check this example project to see how LogBook is integrated:

- [Skeleton](https://github.com/fguillen/Skeleton)

## TODO

Use block configuration instead of `model.log_book_historian` do something like:

    LogBook.conf(:log_book_historian => user) do
      model.save!
    end


## Sate of the art

Beta version but already used in production environments
