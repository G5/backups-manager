@IncidentPoller =
  poll: ->
    setTimeout @updateIncidents, 10000

  updateIncidents: ->
    response = @request()
    debugger
    
    @poll()

  request: ->
    $.get($('#incidents').data('url'))

jQuery ->
  IncidentPoller.poll()
