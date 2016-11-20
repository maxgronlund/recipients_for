class RecipientsFor::AllRecipientsController < ApplicationController
  include RecipientsFor::ReaderServices
  skip_before_filter :verify_authenticity_token

  def create
    swap_all_recipients(params)
    render nothing: true, status: 200, content_type: "text/html"
  end

  private

  def swap_all_recipients(options={})
    recipients = RecipientsFor::Recipient.messageble_recipients(
      options[:messageble_type],
      options[:messageble_id]
    )
    recipients.each do |recipient|
      params[:recipient_id] = recipient.id
      update_recipient_notifications(options)
    end
  end
end
