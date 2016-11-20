module RecipientsFor
  class Subject < ActiveRecord::Base
    self.table_name_prefix = 'rf_'
    has_many :contents, dependent: :destroy
    has_many :reader_infos
    has_many :receipients
    belongs_to :messageable, polymorphic: true
    validates :subject, presence: true


    accepts_nested_attributes_for :contents

    # Get original content from when subject was created
    def content
      return "" if contents.empty? || contents.first.authorable.nil?
      contents.first.content
    end

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

    def replies
      contents.order("created_at DESC") - [contents.first]
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

    # Get number of internal readers
    def internal_readers_count
      reader_infos.where(internal: true).count
    end

    # Mark as unread for all readers and update created_at date
    def mark_as_unread
      touch
      reader_infos.update_all(read: false)
    end
  end
end