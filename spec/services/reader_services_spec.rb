require 'spec_helper'
include RecipientsFor::ReaderServices


RSpec.describe RecipientsFor::ReaderServices do
  #it 'say_hello' do
  #  expect(say_hello).to eq "hello world"
  #end

  it "build reader infos" do
    reciveables = []
    reciveables << TestMock::Reciveable.new(1, "Hui")
    reciveables << TestMock::Reciveable.new(2, "Lui")
    reciveables << TestMock::Reciveable.new(3, "Dui")
    build_reader_infos(TestMock::Car.new(1), reciveables)
    expect(@readers.length).to eq 3
    expect(@readers[0][:name]).to eq 'Hui'
    expect(@readers[0][:read]).to eq false
  end

  it "update recipient notifications" do
    car = TestMock::Car.new(2)
    hui = TestMock::Reciveable.new(4, "Hui")
    RecipientsFor::Recipient.create(
      messageble_type: car.class.name,
      messageble_id: car.id,
      reciveable_type: hui.class.name,
      reciveable_id: hui.id,
      notifications: [
        {notification_type: "email", name: "email", checked: true, internal: false},
        {notification_type: "internal", name: "intern besked", checked: false, internal: true}
      ]
    )

    update_recipient_notifications(
      recipient_id: RecipientsFor::Recipient.first.id,
      notification_type: "email",
      checked: true
    )
  end
end

class TestMock
  class Car
    attr_accessor :id
    def initialize(id)
      @id = id
    end
  end
  class Reciveable
    attr_accessor :id, :name
    def initialize(id, name)
      @id = id
      @name = name
    end

  end
end
