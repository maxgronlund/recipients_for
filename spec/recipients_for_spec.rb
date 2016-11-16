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


end
