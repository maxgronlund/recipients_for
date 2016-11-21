module RecipientsFor
  module MessageServices

    # Get messages read/unread for a receipient
    def message_lists(options={})
      reciveable = options[:reciveable]
      if options[:unread_messages]
        @unread_messages = reciveable_messages(
          reciveable_type: reciveable.class.name,
          reciveable_id:  reciveable.id,
          read:           false
        )
      end

      if options[:read_messages]
        @read_messages = reciveable_messages(
          reciveable_type: reciveable.class.name,
          reciveable_id:  reciveable.id,
          read:           true
        )
      end
    end

    # Find a message_subject and the content for the message
    # Creates a new content for a reply
    # mark the message as read
    # TODO Rename/ breakdown it both find and new
    def show_message(id, persona)
      @subject = RecipientsFor::Subject.includes(:contents).find(id)
      @content = RecipientsFor::Content.new
      RecipientsFor::ReaderInfo.mark_as_read(@subject.id, persona)
    end

    # Mark all messages for a reciveable as read
    def mark_all_messages_as_read(options={})
      RecipientsFor::ReaderInfo.where(
        reciveable_type: options[:reciveable].class.name,
        reciveable_id:   options[:reciveable].id,
      ).update_all(read: true)
    end

    # Create a Subject with Content
    # and post the message
    def create_message(options={})
      author      = options[:author]
      messageable = options[:messageable]
      params      = options[:params]
      subject     = RecipientsFor::Subject.new(params)
      subject.messageable_type  = messageable.class.name
      subject.messageable_id    = messageable.id
      if subject.save
        set_author_on_subject(author, subject)
        create_reader_infos(
          messageble:     messageable,
          subject:        subject
        )
        ActiveSupport::Notifications.instrument('message_created', subject_id: subject.id)
      end
      subject
    end

    # Setup new models for the new form
    def build_message
      @subject  = RecipientsFor::Subject.new
      @content  = RecipientsFor::Content.new
    end

    def find_or_create_receipients(options)
      @messageble    = options[:messageble]
      @personas      = options[:personas]
      @notifications = options[:notifications]
      @recipients    = RecipientsFor::Recipient.find_or_create_receipients(options)
    end

    private

    # The message_subject belongs to the author who created the through the first message_content
    # the message_content was created with nested_attributes without a person_id for security reasons
    # here we secure the author is set on the first message_content
    def set_author_on_subject(author, subject)
      if content =  subject.contents.first
        content.update_attributes(
          authorable_id: author.id,
          authorable_type: author.class.name
        )
      end
    end

    # Take a model.instance and attach a list of ReaderInfo's to it
    def create_reader_infos(options={})
      messageble  = options[:messageble]
      subject     = options[:subject]
      recipients  = RecipientsFor::Recipient.messageble_recipients(
        messageble.class.name,
        messageble.id
      )

      recipients.each do |recipient|
        enable = false
        recipient.notifications.each do |notification|
          enable = true if notification[:checked]
        end
        if enable
          subject.reader_infos.create(
            read:             false,
            uuid:             SecureRandom.uuid,
            reciveable_type:  recipient.reciveable_type,
            reciveable_id:    recipient.reciveable_id,
            recipient_id:     recipient.id,
            internal:         recipient.internal,
            notifications:    recipient.notifications,
            email:            recipient.email
          )
        end
      end
    end

    # Get all messages for a reciveable
    def reciveable_messages(options={})
      subject_ids = RecipientsFor::ReaderInfo.where(
        reciveable_type:  options[:reciveable_type],
        reciveable_id:    options[:reciveable_id],
        read:             options[:read],
        internal:         true
      ).pluck(:subject_id)
     RecipientsFor::Subject.order("updated_at asc").includes(:contents, :reader_infos).where(id: subject_ids)
    end
  end
end