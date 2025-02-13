source "https://rubygems.org"

ruby "3.3.6"
gem "rails", "~> 7.2.1", ">= 7.2.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "cssbundling-rails"
gem "sassc", "~> 2.4.0"

gem "dotenv-rails"

gem "devise"
gem "devise-i18n"
gem "devise-i18n-views"

gem "rails-i18n"

gem "aws-sdk-s3", require: false

gem "geocoder"

gem "ransack"

gem "kaminari"

gem "rails_admin"
gem "cancancan"

gem "image_processing", "~> 1.2"
gem "mini_magick"
gem "carrierwave"
gem "fog-aws"

gem "meta-tags"

gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-twitter2"
gem "omniauth-rails_csrf_protection"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "faker"
  gem "webmock"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
