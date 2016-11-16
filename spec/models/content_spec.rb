require 'spec_helper'


RSpec.describe RecipientsFor::Content do

  before :each do
    setup_dummy_data
  end

  after :each do
    destroy_dummy_data
  end

  it "Get the authors name" do
    expect(@content.author_name).to eq @user.name
  end
end
