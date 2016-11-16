module RecipientsFor
  class Recipient < ActiveRecord::Base
    serialize :notifications
    belongs_to :messageble, polymorphic: true
    belongs_to :reciveable, polymorphic: true
    has_many :reader_infos#, class_name: RecipientsFor::ReaderInfo

    # Get all reciveables for a given messageble
    # Receivables comes in all diffrent colors (User, Person)
    def self.reciveables(messageble)
      reciveables = []
      recipients = where(
        messageble_id: messageble.id,
        messageble_type: messageble.class.name
      )
      recipients.each do |recipient|
        if receiveable = receiveable_for(recipient)
          reciveables << receiveable
        end
      end
      reciveables
    end

    # Get all recipients for a messagble
    def self.messageble_recipients(messageble_type, messageble_id)
      where(
        messageble_type: messageble_type,
        messageble_id: messageble_id
      )
    end

    # Get one receivable from a recipient,
    # Keep code alive if reciveable Class/Model no longer exists
    def self.receiveable_for(recipient)
      defined?(recipient.reciveable_type) ? eval("#{recipient.reciveable_type}.find_by(id: #{recipient.reciveable_id})") : nil
    end

    # Secure there is one and only one receipient for each persona in the system
    # personas can be a mix of all different kind of classes
    def self.find_or_create_receipients(options={})
      messageble    = options[:messageble]
      personas      = options[:personas]
      notifications = options[:notifications]
      internal      = false
      notifications.each do |notification|
        internal = true if notification[:internal] == true
      end
      recipients    = []
      personas.each do |person|
        recipient = RecipientsFor::Recipient.where(
            messageble_type:  messageble.class.name,
            messageble_id:    messageble.id,
            reciveable_type:  person.class.name,
            reciveable_id:    person.id,
          ).first_or_initialize(
            messageble_type:  messageble.class.name,
            messageble_id:    messageble.id,
            reciveable_type:  person.class.name,
            reciveable_id:    person.id,
          )
          recipient.internal      = internal
          recipient.notifications = notifications
          recipient.save
          recipients << recipient
      end
      recipients
    end

    # Return the reciveables email
    def email
      reciveable ? reciveable.email : ""
    end

    def name
      reciveable ? reciveable.name : "NA"
    end

  end
end