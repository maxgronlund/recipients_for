module RecipientsFor
  class ReaderInfo < ActiveRecord::Base
    self.table_name_prefix = 'rf_'
    serialize :notifications
    belongs_to :subject, counter_cache: true
    belongs_to :recipient
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

    # Get number of unread messages for a receivable
    def self.unread_by_count(options={})
      for_reciveable(options, false).count
    end

    # Get all unread messages for a reciveable
    def self.unread_by(options={})
      read_by_reciveable(options, false)
    end

    # Get all read messages for a reciveable
    def self.read_by(options={})
      read_by_reciveable(options, true)
    end

    private

    def self.read_by_reciveable(options={}, read)
      subject_ids = for_reciveable(options, read).pluck(:subject_id)
      RecipientsFor::Subject.includes(:contents, :reader_infos).where(id: subject_ids)
    end

    def self.for_reciveable(options={}, read)
      order("updated_at desc").where(
        reciveable_type:  options[:reciveable_type],
        reciveable_id:    options[:reciveable_id],
        read:             read,
        internal:         true
      )
    end
  end
end