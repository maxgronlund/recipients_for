module RecipientsFor
  class ReaderInfo < ActiveRecord::Base
    self.table_name_prefix = 'rf_'
    serialize :notifications
    belongs_to :subject, counter_cache: true#, class_name: RecipientsFor::Subject
    belongs_to :recipient#, class_name: RecipientsFor::Recipient
    validates :subject_id, presence: true
    validates :reciveable_id, presence: true
    validates :reciveable_type, presence: true
    validates :uuid, presence: true

    # Mark reader info as read
    def mark_as_read!
      update_attributes(read: true)
    end

    # Check if the message is read by a reciveable
    def self.read_by?(subject_id, reciveable)
      find_by(
        subject_id:   subject_id,
        reciveable_type: reciveable.class.name,
        reciveable_id:   reciveable.id,
        read: true
      ).nil? ? false : true
    end

    # Get all reader_infos for a subject
    def self.readers_for(subject)
      RecipientsFor::ReaderInfo.where(subject_id: subject.id)
    end

    # Mark a subject as read by a persona
    def self.mark_as_read(subject_id, persona)
      if reader_info = find_by(
          reciveable_type: persona.class.name,
          reciveable_id: persona.id,
          subject_id: subject_id
        )
        reader_info.update_attributes(read: true)
      end
    end

    # Get the name of the reader
    def name
      recipient.name.nil? ? "NA" : recipient.name
    end
  end
end