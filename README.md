# RecipientsFor

The MessageSystem can be attached to anything in a rails app
When attached it provided with a list of potential recipients.
The sender can select recipients and delivery options for each recipient
Recipients can reply to messages.
For each messages it's possible to se how many readers there is and if they have read the massage
The system is fully customizable. Views, controller and divelivery options can are customizable

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recipients_for'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recipients_for

## Usage

Add this to application.js
    //= require message/recipients

routes.rb

namespace :message do
  resources :contents
  resources :recipients, only: [:create]
  resources :all_recipients, only: [:create]
  resources :downloads, only: [:show]
  put 'mark_all_as_read', to: 'mark_all_as_read#update'
end
resources :messages, path: '/messages', controller: 'message/messages'

:all_recipients, :downloads, 'mark_all_as_read' are optional
-----------------------------------------
Custom ontroller
When you attach a message to a model instance you have to create a controller for that.
In the controller for the view where you want the message system to apear
include the following


    include Message::MessageServices
    include Message::ReaderServices

    def new
      build_message
      set_recipients
    end

    def create
      @message_subject = create_message(
          author: current_user,
          messageable: @schedule,
          personas: @schedule.approved_persons,
          params: message_subject_params
        )
      if @message_subject.persisted?
        redirect_to ffa_course_course_schedule_course_attendance_mails_path(@course, @schedule)
      else
        set_recipients
        render :new
      end
    end


You also have to create two private method like this

    private

    def set_recipients
      find_or_create_receipients(
        messageble: INSTANCE_THE_MESSAGES_ARE_ATTACHED_TO,
        personas: LIST_OF_POTENTIAL_MESSAGE_RECIVERS,
        notifications: [
          {notification_type: "email", name: "email", checked: true, internal: false},
          {notification_type: "internal", name: "intern besked", checked: false, internal: true}
        ]
      )
    end

    def message_subject_params
      params.require(:message_subject).permit!
    end

where
*   messageble: is what you want the message to be about. e.g. a house, a person, anything you like
*   personas: is a list op potential readers of the message whom can be selected/deselected from the new view by the sender
*   notifications: is a list of hashes of options the sender can celect
        * notification_type: is the internal type it will be passed back to the rails ap when a message is send
        * name: is the translation of the message_type used to presend the name to the sender
        * checked: is the default value for the checkboxes where the sende select recivers for a message
        * internal: is if the message should show up in the internal system





-----------------------------------------
Views (haml)
You can write your own views for attaching messages

new

    = render "message/messages/form",
      message_subject: @message_subject,
      message_content: @message_content,
      messageble: @messageble,
      personas: @personas,
      controller: "NAME_OF_YOUR_CUSTOM_CONTROLLER"

    = render "message/recipients_list" , recipients: @recipients, messageble: @messageble


controller is the controller thats handle the post message when the user creates the message
controller: e.g. 'cars' will bounche back to cars_controller.rb
"message/recipients_list" is optional



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxgronlund/recipients_for. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

