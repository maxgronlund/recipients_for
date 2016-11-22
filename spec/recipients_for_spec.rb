require 'spec_helper'

describe RecipientsFor do
  it 'has a version number' do
    expect(RecipientsFor::VERSION).not_to be nil
  end

  describe "#configure" do
    before do
      RecipientsFor.configure do |config|
      end
    end

    it "does nothing" do
    end
  end

  describe "#extend active record models" do
    before :each do
      setup_dummy_data
    end

    it 'get all messages for a messageble' do
      #expect(@test_messageble.message_count).to eq 1
    end
  end


end
