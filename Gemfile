# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in simple_site_crawler.gemspec
gemspec

gem 'rake', '~> 13.0'

gem 'rspec', '~> 3.0'

gem 'rubocop'

group :development do
  gem 'pry-byebug'
  gem 'ruby-debug-ide' if ENV['RAKE_ENV'] == 'development'
end

gem 'async-worker'
gem 'faraday-follow_redirects'
gem 'faraday-typhoeus'
gem 'sitemap-parser', '< 0.6'
