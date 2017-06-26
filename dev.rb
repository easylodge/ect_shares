# For gem developer/contributor:
# Create file called 'dev_config.yml' in your project root with the following
#
# url: 'https://ctaau.vedaxml.com/cta/sys1'
# access_code: 'your access code'
# password: 'your password'
# subscriber_id: 'your subscriber id'
# security_code: 'your security code'
# request_mode: 'test'
#
# run 'bundle console'and then
# load 'dev.rb' to load this seed data

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

require_relative 'spec/schema'

