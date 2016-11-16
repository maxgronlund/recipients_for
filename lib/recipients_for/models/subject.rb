module RecipientsFor
  class Subject < ActiveRecord::Base
    #has_attached_file :attachment,
    #                  url: '/attachments/:id',
    #                  path: ':rails_root/uploads/subjects/:id/:style/:basename.:extension'
    #do_not_validate_attachment_file_type :attachment

    # has_many :contents, dependent: :destroy, class_name: RecipientsFor::Content
    # has_many :reader_infos, class_name: RecipientsFor::ReaderInfo
    # has_many :receipients, class_name: RecipientsFor::Recipient
    # validates :subject, presence: true
    #
    # accepts_nested_attributes_for :contents

    # get content from first message_content
    # use when ther is only one message_content
    # def content
    #   contents.empty? ? "" : contents.first.content
    # end
    #
    # # get number of readers from first message_content
    # # use when ther is only one message_content
    # def first_content_readers_count
    #   reader_infos_count
    # end
    #
    # # get the author name for the original subject
    # def author_name
    #   return "" if contents.empty?
    #   contents.first.author_name
    # end
    #
    # def content
    #   return "" if contents.empty? || contents.first.authorable.nil?
    #   contents.first.content
    # end
    #
    # def latest_content_created_at
    #   return DateTime.now if contents.empty?  || contents.last.created_at.nil?
    #   contents.last.created_at
    # end
    #
    # def reply_count
    #   contents_count - 1
    # end
    #
    # def read_by_count
    #   reader_infos.where(read: true).count
    # end
    #
    # def read_by?(reciveable)
    #   if reader_info = reader_infos.find_by(
    #       reciveable_type: reader.class.name,
    #       reciveable_id: reader.id
    #     )
    #     return reader_info.read ? "√" : "Unread"
    #   end
    #   "?"
    # end
    #
    # def unread_messages(recipient)
    #   subject_ids = reader_infos.where(
    #     reciveable_type: recipient.class.name,
    #     reciveable_id: recipient.id).pluck(:subject_id)
    #   Message::Subject.where(id: subject_ids)
    # end
    #
    # def internal_readers_count
    #   reader_infos.where(internal: true).count
    # end
    #
    # def readers_count
    #   reader_infos.where(enable: true).count
    # end
    #
    # def mark_as_unread
    #   reader_infos.update_all(read: false)
    # end
  end
end