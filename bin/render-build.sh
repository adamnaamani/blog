#!/usr/bin/env bash
# exit on error
set -o errexit

bundle exec puma -C config/puma.rb
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate