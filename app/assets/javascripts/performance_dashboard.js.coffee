@IncidentPoller =
  poll: ->
    setTimeout =>
      @request()
    , 10000

  request: ->
    $.get($('#incidents').data('url'), after: @getIncidentAfterId())

  updateIncidents: (incidents, expired_incidents) ->
    if incidents.length > 0
      if $('#incidents .incident').length > 0
        $('#incidents .incident').first().prepend($(incidents))
      else
        $('#incidents p').replaceWith($(incidents))
    if expired_incidents.length > 0
      debugger
      incidents = $('.incident')
      if incidents.length > 0
        debugger
        $.each incidents, (incident) ->
          $.each expired_incidents, (dead) ->
            debugger
            if incident.hasClass(dead["incident_number"])
              incident.remove()
    @poll()

  getIncidentAfterId: ->
    incidentIds = $('#incidents .incident').map (idx, elem)->
      return $(elem).data('id')
    return Math.max(incidentIds...)


jQuery ->
  IncidentPoller.poll()
