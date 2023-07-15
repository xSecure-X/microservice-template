source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "3.2.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem 'pg', '~> 1.1', '>= 1.5.3'
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end
group :development do
  gem "web-console"
end
group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "pry"
end
gem "cancancan"
gem "devise"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
group :development, :test do
  gem 'rspec-rails'
end
gem 'rswag'
gem 'rack-cors'
