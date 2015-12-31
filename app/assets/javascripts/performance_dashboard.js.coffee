@IncidentPoller =
  poll: ->
    setTimeout @request, 10000

  request: ->
    incidentIds = $('#incidents .incident').map (idx, elem)->
      return $(elem).data('id')
    latestIncident = Math.max(incidentIds...)
    $.get($('#incidents').data('url'), after: latestIncident)

  updateIncidents: (incidents, new_incidents, expired_incidents, callback) ->
    if new_incidents.length > 0
      if $('#incidents .incident').length > 0
        $('#incidents .incident').first().prepend($(new_incidents))
      else
        $('#incidents p').replaceWith($(new_incidents))

    if incidents.length > 0 && $('#incidents .incident').length > 0
      $('#incidents').html().replaceWith($(incidents))

    @poll()

    if expired_incidents.length > 0
      incidents = $('.incident')
      if incidents.length > 0
        $.each incidents, (incident) ->
          $.each expired_incidents, (dead) ->
            if incident.hasClass(dead["incident_number"])
              incident.remove()

jQuery ->
  IncidentPoller.poll()
