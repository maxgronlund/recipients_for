module RecipientsFor
  class Subject < ActiveRecord::Base
    self.table_name_prefix = 'rf_'
    #has_attached_file :attachment,
    #                  url: '/attachments/:id',
    #                  path: ':rails_root/uploads/subjects/:id/:style/:basename.:extension'
    #do_not_validate_attachment_file_type :attachment

    has_many :contents, dependent: :destroy
    has_many :reader_infos
    has_many :receipients
    validates :subject, presence: true

    accepts_nested_attributes_for :contents

    # Get original content from when subject was created
    def content
      return "" if contents.empty? || contents.first.authorable.nil?
      contents.first.content
    end

    # Get number of readers from first message_content
    # use when ther is only one message_content
    # def first_content_readers_count
    #   reader_infos_count
    # end

    # Get the author name for the original subject
    def author_name
      return "" if contents.empty?
      contents.first.author_name
    end

    # Get date and time for when last comment was posted
    def latest_content_created_at
      return DateTime.now if contents.empty?  || contents.last.created_at.nil?
      contents.last.created_at
    end

    # Get number of replies
    def reply_count
      contents_count - 1
    end

    # Get number of readers that has read the subject
    def read_by_count
      reader_infos.where(read: true).count
    end

    # Check if the subject is read by a recipient
    def read_by?(reciveable)
      if reader_info = reader_infos.find_by(
          reciveable_type: reciveable.class.name,
          reciveable_id: reciveable.id
        )
        return reader_info.read ? "√" : "Unread"
      end
      "?"
    end

    # Get unread messages for a recipient
    #def unread_messages(recipient)
    #  subject_ids = reader_infos.where(
    #    reciveable_type: recipient.class.name,
    #    reciveable_id: recipient.id).pluck(:subject_id)
    #  Message::Subject.where(id: subject_ids)
    #end

    # Get number of internal readers
    def internal_readers_count
      reader_infos.where(internal: true).count
    end

    # Mark as unread for all readers
    def mark_as_unread
      reader_infos.update_all(read: false)
    end
  end
end