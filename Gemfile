source 'https://rubygems.org'

gem 'rails', '3.2.9'

gem 'sqlite3'

gem "haml-rails"
gem "simple_form"
gem "devise"
gem "responders"
gem "cancan"
gem "wicked_pdf"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails"
  gem "twitter-bootstrap-rails", :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
  gem "therubyracer", "0.10.2"
end

gem 'jquery-rails'

guard_notifications = true
group :development do
  gem "spork-rails"
end

group :development, :test do
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem "rspec-rails"
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem "shoulda-matchers"
  gem "capybara"
  gem "factory_girl"
  gem "simplecov", :require => false
  gem "database_cleaner"
  gem "fuubar"
end
