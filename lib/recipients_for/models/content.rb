module RecipientsFor
  class Content < ActiveRecord::Base
    self.table_name_prefix = 'rf_'
    belongs_to :subject, counter_cache: true
    belongs_to :authorable, polymorphic: true
    validates :body, presence: true
    # virtual parameter
    attr_writer   :return_path, :messageble_var_name, :render_error_path


    # Get the authors name
    def author_name
      authorable.name
    end
  end
end
