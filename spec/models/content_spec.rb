require 'spec_helper'

RSpec.describe RecipientsFor::Content do
  before :each do
    setup_dummy_data
  end

  it "Get the authors name" do
    expect(@test_content.author_name).to eq @test_user.name
  end
end
