require 'spec_helper'


RSpec.describe RecipientsFor::Subject do

  before :each do
    setup_dummy_data
  end

  after :each do
    destroy_dummy_data
  end

  it "Get original content from when subject was created" do
    expect(@subject.content).to eq @content.content
  end

  it "Get the author name for the original subject" do
    expect(@subject.author_name).to eq @user.name
  end

  it "Get date and time for when last comment was posted" do
    expect(@subject.latest_content_created_at).not_to eq nil
  end

  it "Get number of replies" do
    expect(@subject.reply_count).to eq 1
  end

  it "Get number of readers that has read the subject" do
    expect(@subject.read_by_count).to eq 1
  end

  it "Check if the subject is read by a recipient" do
    expect(@subject.read_by?(@user)).to eq "√"
  end

  #it "Get unread messages for a recipient" do
  #  @subject.unread_messages(@recipient2)
  #end

  it "Get number of internal readers" do
    expect(@subject.internal_readers_count).to eq 1
  end

  it "Mark as unread for all readers" do
    expect(@subject.read_by_count).to eq 1
    @subject.mark_as_unread
    expect(@subject.read_by_count).to eq 0
  end


end
