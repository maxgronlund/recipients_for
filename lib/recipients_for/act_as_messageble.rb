module RecipientsFor
  module ActAsMessageble
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def act_as_messageble(options = {})
         cattr_accessor :yaffle_text_field
        self.yaffle_text_field = (options[:yaffle_text_field] || :last_squawk).to_s

        include RecipientsFor::ActAsMessageble::LocalInstanceMethods

      end
    end

    module LocalInstanceMethods

      def all_messages_count()
        all_messages.count
      end

      def all_messages()
        RecipientsFor::Subject.where(
          messageable_type: self.class.name,
          messageable_id: id
        )
      end
    end


  end
end
ActiveRecord::Base.send :include, RecipientsFor::ActAsMessageble