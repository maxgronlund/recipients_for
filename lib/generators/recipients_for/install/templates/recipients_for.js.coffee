# the message system has a list of recipients
# for each recipient the sender can select what kind of message
# the recipient will receive
ready = ->
  $('.recipient_checkbox').click ->
    notification_type  = $(this).attr 'notification_type'
    recipient_id       = $(this).attr 'recipient_id'
    checkbox_state     = $(this).is(":checked")
    authenticity_token = $(this).attr 'authenticity_token'
    post_message_receipient(checkbox_state, notification_type, recipient_id, authenticity_token)

  $(".select_all_recipients").click ->
    messageble_type     = $(this).attr 'messageble_type'
    messageble_id       = $(this).attr 'messageble_id'
    notification_type   = $(this).attr 'notification_type'
    checkbox_state      = $(this).is(":checked")
    authenticity_token = $(this).attr 'authenticity_token'
    swap_all_receipient(messageble_type, messageble_id, checkbox_state, notification_type, authenticity_token)
    set_all_checkboxes(notification_type, checkbox_state)

$(document).ready(ready)
$(document).on('page:load', ready)


post_message_receipient = (checkbox_state, notification_type, recipient_id, authenticity_token) ->
  console.log recipient_id
  data = {
    checked: checkbox_state,
    recipient_id: recipient_id,
    notification_type: notification_type,
    authenticity_token: authenticity_token
  }

  $.ajax({
    type: "POST",
    url: "/recipients_for/recipients",
    data: data,
    success: null,
    dataType: 'json'
  });

swap_all_receipient = (messageble_type, messageble_id, checkbox_state, notification_type, authenticity_token) ->
  console.log(notification_type)
  data = {
   messageble_type: messageble_type,
   messageble_id: messageble_id,
   checked: checkbox_state,
   notification_type: notification_type,
   authenticity_token: authenticity_token
  }

  $.ajax({
   type: "POST",
   url: "/recipients_for/all_recipients",
   data: data,
   success: null,
   dataType: 'json'
  });

set_all_checkboxes = (notification_type, checkbox_state) ->
  $("."+notification_type).each ->
    $(this).prop('checked', checkbox_state);


