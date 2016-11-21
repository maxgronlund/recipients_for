module RecipientsFor
  module Messages
    extend ActiveSupport::Concern

    included do
    end

    def message_count
      all_messages.count
    end

    def all_messages
      RecipientsFor::Subject.where(
        messageable_type: self.class.name,
        messageable_id: id
      )
    end
  end
end