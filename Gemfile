source "https://rubygems.org"
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby "3.3.6"

gem "ahoy_matey"
gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "devise"
gem "image_processing"
gem "importmap-rails"
gem "kamal", require: false
gem "kaminari"
gem "nokogiri"
gem "pg"
gem "propshaft"
gem "puma"
gem "rails", "~> 8.0.2"
gem "redis"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3.0.0"
gem "tailwindcss-ruby", "~> 3.4.15"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
