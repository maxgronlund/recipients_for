module RecipientsFor
  module ActAsMessageble
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def act_as_messageble(options = {})
        include RecipientsFor::ActAsMessageble::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods

      def all_messages_count()
        all_messages.count
      end

      def all_messages()
        RecipientsFor::Subject.order("updated_at DESC").where(
          messageable_type: self.class.name,
          messageable_id: id
        )
      end
    end

    def all_readers(subject)
      @readers = []
      if reader_infos = subject.reader_infos
        reader_infos.each do |reader_info|
          @readers << {
            name: reader_info.name,
            read: reader_info.read
          }
        end
      end
    end


  end
end
ActiveRecord::Base.send :include, RecipientsFor::ActAsMessageble