require 'spec_helper'
include RecipientsFor::ReaderServices

describe RecipientsFor do
  it 'say_hello' do
    expect(say_hello).to eq "hello world"
  end
end