source 'https://rubygems.org'

gem 'rails', '~> 3.2.11'
gem 'bootstrap-sass', '2.0.4'
gem 'devise', '~> 2.2.0'
gem 'cancan', '~> 1.6.8'
gem "crummy", "~> 1.6.0"
gem 'yaml_db', "~> 0.2.3"

# To fix rake version to compatible one
# See https://stackoverflow.com/a/35893625/4786733
gem 'rake', '< 11.0'

# SQLite und Rspec benötigen wir nur in Development und Test
group :development, :test do
	gem 'sqlite3', "~> 1.3.6"
	gem 'rspec-rails', '2.12.0'
  gem 'factory_girl_rails', '4.1.0'
end

group :development do
	# Annotate zeigt die Modellanotationen in den Controllern an
	gem 'annotate', '2.5.0'
	# wirble macht die Konsole hübsch
	gem 'wirble', "~> 0.1.3"
end



group :test do
	gem 'capybara', '1.1.2'
  gem 'faker', "~> 1.1.2"
  gem 'guard-rspec', "~> 2.3.3"
  gem 'launchy', "~> 2.1.2"
  gem 'simplecov', "~> 0.7.1"
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'sass-rails', '~> 3.2.3'
	gem 'coffee-rails', '~> 3.2.1'

	# See https://github.com/sstephenson/execjs#readme for more supported runtimes
	# gem 'therubyracer', :platforms => :ruby

	gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', "~> 2.1.4"
gem 'jquery-ui-rails', "~> 3.0.1"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
#
