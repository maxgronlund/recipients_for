require 'spec_helper'


RSpec.describe RecipientsFor::Subject do

  before :each do
    setup_dummy_data
  end

  it "Get body from origianl message" do
    expect(@test_subject.title).to eq "Your head is not an artifact!"
  end

  it "Get the author name for the original subject" do
    expect(@test_subject.author_name).to eq @test_user.name
  end

  it "Get date and time for when last comment was posted" do
    expect(@test_subject.latest_content_created_at).not_to eq nil
  end

  it "Get number of replies" do
    expect(@test_subject.reply_count).to eq 1
  end

  it "Get number of readers that has read the subject" do
    expect(@test_subject.read_by_count).to eq 1
  end

  it "Check if the subject is read by a recipient" do
    expect(@test_subject.read_by?(@test_user)).to eq "√"
  end

  #it "Get unread messages for a recipient" do
  #  @test_subject.unread_messages(@test_recipient2)
  #end

  it "Get number of internal readers" do
    expect(@test_subject.internal_readers_count).to eq 1
  end

  it "Mark as unread for all readers" do
    expect(@test_subject.read_by_count).to eq 1
    @test_subject.mark_as_unread
    expect(@test_subject.read_by_count).to eq 0
  end


end
