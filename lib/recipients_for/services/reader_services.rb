module RecipientsFor
  module ReaderServices
    #def say_hello
    #  "hello world"
    #end

    # utility function that take a list of recivables
    # creates a hash with name and if message is read
    def build_reader_infos(subject, reciveables)
      @readers = []
      reciveables.each do |reciveable|
        @readers << {
          name: reciveable.name,
          read: RecipientsFor::ReaderInfo.read_by?(subject.id, reciveable)
        }
      end
    end

    def update_recipient_notifications(options={})
      recipient         = RecipientsFor::Recipient.find(options[:recipient_id].to_i)
      notification_type = options[:notification_type]
      checked           = options[:checked] == "true"
      notifications     = recipient.notifications
      internal          = false
      notifications.each do |notification|
        if notification[:notification_type] ==  notification_type
          notification[:checked] = checked
        end
        if notification[:internal] && checked
          internal = true
        end
      end
      recipient.update_attributes(notifications: notifications, internal: internal)
      subject = build(:subject)

    end
  end
end