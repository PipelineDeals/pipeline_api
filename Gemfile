# A sample Gemfile
source "https://rubygems.org"

gem 'activesupport'
gem 'httparty'

group :development, :test, :ci do
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rspec'
  gem "vcr"
  gem "webmock"
end

group :test do
  gem 'rspec_junit_formatter', '0.4.1'
  gem 'simplecov', require: false
  gem 'pry'
end
