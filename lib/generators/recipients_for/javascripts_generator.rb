require 'rails/generators/base'
module RecipientsFor
  module Generators
    class JavascriptsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../vendor/assets/javascripts", __FILE__)
      desc "Copies recipients_for.js.coffe to your application."
      def install_javascript
        template "recipients_for.js.coffee", "app/assets/javascripts/recipients_for/RENAME_ME.js.coffee.template"
      end

      def show_readme
        readme "README"
      end

    end
  end
end