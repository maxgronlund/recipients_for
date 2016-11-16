$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'recipients_for'
require 'generators/recipients_for/install/templates/migration.rb'
require 'support/spec_migration.rb'
require 'recipients_for/models/content'
require 'recipients_for/models/subject'
require 'recipients_for/models/reader_info'
require 'recipients_for/models/recipient'
require 'awesome_print'
require 'faker'
require 'support/factory_girl'
require 'support/car'
require 'support/user'
require 'paperclip'

RSpec.configure do |config|

  config.before :each do
    clear_db
  end

  config.after :suite do
    RecipientsForMigration.down
    SpecMigration.down
  end

end

def setup_db
  configs = YAML.load_file('spec/database.yml')
  ActiveRecord::Base.configurations = configs

  db_name = ENV['DB'] || 'sqlite'

  puts "Testing with ActiveRecord #{ActiveRecord::VERSION::STRING} on #{db_name}"
  ActiveRecord::Base.establish_connection(db_name.to_sym)
  ActiveRecord::Base.default_timezone = :utc
  ActiveRecord::Migration.verbose = false
  RecipientsForMigration.up
  SpecMigration.up
end

def clear_db
  RecipientsFor::Subject.delete_all
  RecipientsFor::Content.delete_all
  RecipientsFor::Recipient.delete_all
  RecipientsFor::ReaderInfo.delete_all
  User.delete_all
  Car.delete_all
end

setup_db