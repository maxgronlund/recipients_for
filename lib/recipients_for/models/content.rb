module RecipientsFor
  class Content < ActiveRecord::Base
    #belongs_to :subject, counter_cache: true, class_name: RecipientsFor::Subject
    belongs_to :authorable, polymorphic: true
    validates :content, presence: true
    # virtual parameter
    attr_writer   :return_path

    # Get the authors name
    def author_name
      authorable.name
    end
  end
end

# RecipientsFor::Content