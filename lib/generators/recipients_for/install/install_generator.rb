module RecipientsFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      def create_configuration
        template "recipients_for.rb", "config/initializers/recipients_for.rb"
      end

      def create_migrations
        if ActiveRecord::Base.timestamped_migrations
          next_migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          next_migration_number = "%.3d" % (current_migration_number(dirname) + 1)
        end
        template "migration.rb",  "db/migrate/#{next_migration_number}_recipients_for_migration.rb"
      end


    end
  end
end