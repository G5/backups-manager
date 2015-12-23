@IncidentPoller =
  poll: ->
    setTimeout @request, 10000

  request: ->
    $.get($('#incidents').data('url'))

jQuery ->
  IncidentPoller.poll()
