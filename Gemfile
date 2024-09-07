source "https://rubygems.org"
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby "3.3.5"

gem "ahoy_matey"
gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "devise"
gem "image_processing"
gem "importmap-rails"
gem "kaminari"
gem "nokogiri"
gem "pg"
gem "puma"
gem "rails", "~> 7.2.1"
gem "redis"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "spring"
end
