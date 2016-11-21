require 'rails/generators/base'
module RecipientsFor
  module Generators
    class ControllersGenerator < Rails::Generators::Base
      source_root File.expand_path("../install/templates/controllers", __FILE__)
      desc "Copies controllers to your application."
      def install_javascript
        template "all_recipients_controller.rb", "app/controllers/recipients_for/all_recipients_controller.rb"
        template "recipients_controller.rb", "app/controllers/recipients_for/recipients_controller.rb"
      end

      def show_readme
        readme "README"
      end
    end

  end
end