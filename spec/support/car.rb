class Car < ActiveRecord::Base

  include RecipientsFor::Messages

end
