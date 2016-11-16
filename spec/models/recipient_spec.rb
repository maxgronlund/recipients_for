require 'spec_helper'


RSpec.describe RecipientsFor::Recipient do

  before :each do
    @messageble = Car.create(brand: "Ford", model: "Expedition")
    @personas = []
    @recipients = []
    (1..10).to_a.each do |id|
      user = User.create(name: Faker::Name.name, email: Faker::Internet.email)
      @recipients << RecipientsFor::Recipient.create(
        messageble_type: @messageble.class.name,
        messageble_id: @messageble.id,
        reciveable_type:  user.class.name,
        reciveable_id:  user.id
      )
      @personas << user
    end
  end

  it "Get all reciveables for a given messageble" do
    reciveables = RecipientsFor::Recipient.reciveables(@messageble)
    expect(reciveables.count).to eq 10
    expect(reciveables[0].class.name).to eq 'User'
  end

  it "Get all recipients for a messagble" do
    recipients = RecipientsFor::Recipient.messageble_recipients(@messageble.class.name, @messageble.id )
    expect(recipients.count).to eq 10
    expect(recipients[0].class.name).to eq 'RecipientsFor::Recipient'
  end

  it "Get one receivable from a recipient" do
    user = RecipientsFor::Recipient.receiveable_for(RecipientsFor::Recipient.first)
    expect(user.id).to eq @personas[0].id
  end

  it "Secure there is one and only one receipient for each persona in the system" do
    RecipientsFor::Recipient.find_or_create_receipients(
      messageble: @messageble,
      personas: @personas,
      notifications: [
        {notification_type: "email", name: "email", checked: true, internal: false},
        {notification_type: "internal", name: "intern besked", checked: false, internal: true}
      ]
    )
  end

  it "Return the reciveables email" do
    expect(@recipients[0].email).to eq @personas[0].email
  end

  it "Return the reciveables name" do
    expect(@recipients[0].name).to eq @personas[0].name
  end
end
