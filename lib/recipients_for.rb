require 'rails'
require 'active_record'
require "recipients_for/version"
require "recipients_for/services/reader_services"
require "recipients_for/services/message_services"
require "recipients_for/models/reader_info"
require "recipients_for/models/subject"
require "recipients_for/models/content"
require "recipients_for/models/recipient"
require "recipients_for/act_as_messageble"



module RecipientsFor
  class Engine < ::Rails::Engine

  end
  def self.configure
  end
end
