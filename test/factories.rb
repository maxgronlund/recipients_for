FactoryGirl.define do
  factory :subject, class: RecipientsFor::Subject do
    subject "Ford Comander 1900"
    contents_count 1
    reader_infos_count 1
    messageable_type ""
    messageable_id 1
  end

  factory :recipient, class: RecipientsFor::Recipient do
    messageble_type "TestMock::Messageble"
    messageble_id 0
    reciveable_type "TestMock::Persona"
    reciveable_id 0
    notifications [
        {notification_type: "email", name: "email", checked: true, internal: false},
        {notification_type: "internal", name: "intern besked", checked: false, internal: true}
      ]

  end

end
