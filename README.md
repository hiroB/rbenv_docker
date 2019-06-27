# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

2.6.3

* Start Application

# bundle install for local directory
bundle install --path vendor/bundle

# create secret key
bundle exec rake secret

# start unicorn
SECRET_KEY_BASE="[SECRET_KEY]" RAILS_ENV=development bundle exec unicorn_rails -c config/unicorn.rb -D
