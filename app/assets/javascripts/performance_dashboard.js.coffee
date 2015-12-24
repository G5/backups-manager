@IncidentPoller =
  poll: ->
    setTimeout @request, 10000

  request: ->
    $.get($('#incidents').data('url'), after: $('.incident').first().data('id'))

  addIncidents: (incidents) ->
    if incidents.length > 0
      $('#incidents .incident').first().prepend($(incidents))
    @poll()

jQuery ->
  IncidentPoller.poll()

$('.document').bind 'DOMSubtreeModified', IncidentPoller.addIncidents
