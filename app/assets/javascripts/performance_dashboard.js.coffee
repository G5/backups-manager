@IncidentPoller =
  poll: ->
    setTimeout =>
      @request()
    , 10000

  request: ->
    $.get($('#incidents').data('url'), after: @getIncidentAfterId())

  addIncidents: (incidents) ->
    if incidents.length > 0
      $('#incidents .incident').first().prepend($(incidents))
    @poll()

  getIncidentAfterId: ->
    incidentIds = $('#incidents .incident').map (idx, elem)->
      return $(elem).data('id')
    return Math.max(incidentIds...)


jQuery ->
  IncidentPoller.poll()
