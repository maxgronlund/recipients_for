require 'spec_helper'


RSpec.describe RecipientsFor::ReaderInfo do

  before :each do
    setup_dummy_data
    @reader_info.update_attributes(read: false)
  end

  after :each do
    destroy_dummy_data
  end

  it "Check if the message is read by a reciveable" do
    read = RecipientsFor::ReaderInfo.read_by?(@subject.id, @user)
    expect(read).to eq false
    @reader_info.mark_as_read!
    read = RecipientsFor::ReaderInfo.read_by?(@subject.id, @user)
    expect(read).to eq true
  end

  it "Mark a subject as read by a persona" do
    expect(@reader_info.read).to eq false
    @reader_info.mark_as_read!
    expect(@reader_info.read).to eq true
  end

  it "Get the name of the reader" do
    expect(@reader_info.name).not_to be "NA"
  end

end
