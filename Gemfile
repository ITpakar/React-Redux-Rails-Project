source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 5.0.0.rc1'
gem 'pg'
gem 'therubyracer', platforms: :ruby
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'listen'
gem 'kaminari'
gem "paperclip"
gem 'dotenv-rails'
gem 'swagger-docs'
gem "react_on_rails", "~> 5"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
if ENV["DISABLE_TURBOLINKS"].nil? || ENV["DISABLE_TURBOLINKS"].strip.empty?
  if ENV["ENABLE_TURBOLINKS_5"].nil? || ENV["ENABLE_TURBOLINKS_5"].strip.empty?
    gem 'turbolinks', '2.5.3'
  else
    gem 'turbolinks', '~> 5.0.0.beta2'
  end
end



# For Authentication
gem 'devise'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

gem 'rails_12factor', group: :production