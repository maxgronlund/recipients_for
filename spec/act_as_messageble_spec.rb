require 'spec_helper'

RSpec.describe RecipientsFor::ActAsMessageble do
  before :each do
    setup_dummy_data
  end

  it "Get all messages" do
    expect(@test_messageble.all_messages.length).to eq 1
  end

  it "Get all messages count" do
    expect(@test_messageble.all_messages_count).to eq 1
  end
end
