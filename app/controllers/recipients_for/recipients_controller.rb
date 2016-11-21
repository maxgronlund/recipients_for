class RecipientsFor::RecipientsController < ApplicationController
  include RecipientsFor::ReaderServices
  def create
    update_recipient_notifications(params)
    render nothing: true, status: 200, content_type: "text/html"
  end
end

