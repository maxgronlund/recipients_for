require 'spec_helper'


RSpec.describe RecipientsFor::ReaderInfo do

  before :each do
    @user   = User.create(name: Faker::Name.name, email: Faker::Internet.email)

    @messageble = Car.create(brand: "Ford", model: "Expedition")
    @subject = RecipientsFor::Subject.create(
      subject:          Faker::Lorem.sentence,
      messageable_type: @messageble.class.name,
      messageable_id:   @messageble.id
    )
    @recipient = RecipientsFor::Recipient.create(
      messageble_type:  @messageble.class.name,
      messageble_id:    @messageble.id,
      reciveable_type:  @user.class.name,
      reciveable_id:    @user.id
    )
    @reader_info = RecipientsFor::ReaderInfo.create(
      read: false,
      uuid:             SecureRandom.uuid,
      subject_id:       @subject.id,
      recipient_id:     @recipient.id,
      reciveable_type:  @user.class.name,
      reciveable_id:    @recipient.id,
      internal:         true,
      notifications:    [
        {notification_type: "email", name: "email", checked: true, internal: false},
        {notification_type: "internal", name: "intern besked", checked: false, internal: true}
      ]
    )
  end

  it "Check if the message is read by a reciveable" do
    read = RecipientsFor::ReaderInfo.read_by?(@subject.id, @user)
    expect(read).to eq false
    @reader_info.mark_as_read!
    read = RecipientsFor::ReaderInfo.read_by?(@subject.id, @user)
    expect(read).to eq true
  end

  it "Mark a subject as read by a persona" do
    expect(@reader_info.read).to eq false
    @reader_info.mark_as_read!
    expect(@reader_info.read).to eq true
  end

  it "Get the name of the reader" do
    expect(@reader_info.name).not_to be "NA"
  end

end
