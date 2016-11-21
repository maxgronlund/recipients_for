require 'spec_helper'
include RecipientsFor::MessageServices


RSpec.describe RecipientsFor::MessageServices do
  before :each do
    setup_dummy_data
    @personas = []
    (1..10).to_a.each do
      @personas << User.create(name: Faker::Name.name, email: Faker::Internet.email)
    end
  end

  it "Get messages read/unread for a receipient" do
    message_lists({
      reciveable: @test_user,
      read_messages: true,
      unread_messages: true
    })
    expect(@unread_messages).to eq []
    expect(@read_messages.count).to eq 1
  end

  # it "Get all messages for a subject" do
  #   expect(all_messageble_messages(@test_messageble).count).to eq 1
  # end

  it "Find a message_subject and the content for the message
      Creates a new content for a reply
      and mark the message as read" do
      show_message(@test_subject.id, @test_user)
      expect(@subject).to eq @test_subject
      expect(@content.persisted?).to eq false
      expect(@test_subject.read_by?(@test_user)).to eq "√"
  end

  it "Mark all messages for a reciveable as read" do
    mark_all_messages_as_read(
      reciveable: @test_user
    )
  end

  it "Create a Subject with Content
      and post the message" do
    create_message(
      author:       @test_user,
      messageable:  @test_messageble,
      params:       {
        title: Faker::Lorem.sentence,
        messageable_type: @test_messageble.class.name,
        messageable_id:   @test_messageble.id}
    )
  end

  it "Setup new models for the new form" do
    build_message
    expect(@subject.persisted?).to eq false
    expect(@content.persisted?).to eq false
  end

  it "Find or create receipients" do
    find_or_create_receipients(
      messageble: @test_messageble,
      personas: @personas,
      notifications:    [
        {notification_type: "email", name: "email", checked: true, internal: false},
        {notification_type: "internal", name: "intern besked", checked: false, internal: true}
      ]
    )
    expect(RecipientsFor::Recipient.count).to eq 11
  end

  it "Set the author on a subject" do
    new_name = Faker::Name.name
    @test_user.update_attributes(name: new_name)
    set_author_on_subject(@test_user, @test_subject)
    expect(@test_subject.author_name).to eq new_name
  end

  it "Take a model.instance and attach a list of ReaderInfo's to it" do
    create_reader_infos(
      messageble: @test_messageble,
      subject: @test_subject
    )
  end

  it "Get all messages for a reciveable" do
    read_messages = reciveable_messages(
      reciveable_type: @test_user.class.name,
      reciveable_id: @test_user.id,
      read: true
    )
    expect(read_messages.count).to eq 1

    unread_messages = reciveable_messages(
      reciveable_type: @test_user.class.name,
      reciveable_id: @test_user.id,
      read: false
    )
    expect(unread_messages).to eq []
  end

end
