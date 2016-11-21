require 'spec_helper'

RSpec.describe RecipientsFor::Messages do
  before :each do
    setup_dummy_data
  end

  it "Get all messages" do
    expect(@test_messageble.all_messages.length).to eq 1
  end
end
