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

def setup_dummy_data
  @test_messageble      = Car.create(brand: "Ford", model: "Expedition")
  @test_subject    = RecipientsFor::Subject.create(
    subject:          Faker::Lorem.sentence,
    messageable_type: @test_messageble.class.name,
    messageable_id:   @test_messageble.id
  )
  @test_user   = User.create(name: Faker::Name.name, email: Faker::Internet.email)
  @test_recipient = RecipientsFor::Recipient.create(
    messageble_type:  @test_messageble.class.name,
    messageble_id:    @test_messageble.id,
    reciveable_type:  @test_user.class.name,
    reciveable_id:    @test_user.id,
    notifications:    [
      {notification_type: "email", name: "email", checked: true, internal: false},
      {notification_type: "internal", name: "intern besked", checked: false, internal: true}
    ]
  )
  @test_content = @test_subject.contents.create(
    content:         Faker::Lorem.sentence,
    authorable_type: @test_user.class.name,
    authorable_id:   @test_user.id
  )
  @test_content2 = @test_subject.contents.create(
        content:         Faker::Lorem.sentence,
        authorable_type: @test_user.class.name,
        authorable_id:   @test_user.id
      )
  @reader_info = RecipientsFor::ReaderInfo.create(
    read: true,
    uuid:             SecureRandom.uuid,
    subject_id:       @test_subject.id,
    recipient_id:     @test_recipient.id,
    reciveable_type:  @test_user.class.name,
    reciveable_id:    @test_user.id,
    internal:         true,
    notifications:    [
      {notification_type: "email", name: "email", checked: true, internal: false},
      {notification_type: "internal", name: "intern besked", checked: false, internal: true}
    ]
  )
end

setup_db