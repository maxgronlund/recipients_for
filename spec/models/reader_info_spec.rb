require 'spec_helper'


RSpec.describe RecipientsFor::ReaderInfo do

  before :each do
    setup_dummy_data
    @reader_info.update_attributes(read: false)
  end

  it "Check if the message is read by a reciveable" do
    read = RecipientsFor::ReaderInfo.read_by?(@test_subject.id, @test_user)
    expect(read).to eq false
    @reader_info.mark_as_read!
    read = RecipientsFor::ReaderInfo.read_by?(@test_subject.id, @test_user)
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

  it "Get number of unread messages for a receivable" do
    count = RecipientsFor::ReaderInfo.unread_by_count(
      reciveable_type:  @test_user.class.name,
      reciveable_id:    @test_user.id
    )
    expect(count).to be 1
  end

  it "Get all unread messages for a reciveable" do
    subjects =  RecipientsFor::ReaderInfo.unread_by(
      reciveable_type:  @test_user.class.name,
      reciveable_id:    @test_user.id
    )
    expect(subjects.count).to be 1
    expect(subjects[0].class.name).to eq "RecipientsFor::Subject"
  end

  it "Get all read messages for a reciveable" do
    @reader_info.update_attributes(read: true)
    subjects =  RecipientsFor::ReaderInfo.read_by(
      reciveable_type:  @test_user.class.name,
      reciveable_id:    @test_user.id
    )
    expect(subjects.count).to be 1
    expect(subjects[0].class.name).to eq "RecipientsFor::Subject"
  end

end
