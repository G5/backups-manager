# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.appsList ||= ['cms', 'dsh']

window.toggleAppsGroups = ->
  debugger
  $(".app-title").each (i, title) ->
    $(title).click ->
      if $(title).hasClass('show')
        $(title).removeClass('show')
        $(title).next('.app-list').removeClass('show')
      else
        $(title).addClass('show')
        $(title).next('.app-list').addClass('show')

$(document).ready ->
  window.appsController = new AppsController unless $('.app').hasClass('orgs')

class AppsController
  constructor: ->
    @updateAppsVersions()
    window.toggleAppsGroups()

  updateAppsVersions: ->
    $(".app-title").each (idx, elem) ->
      master_version = $(elem).find('.version-value')
      if master_version
        master_version = master_version.text()

        ul = $(elem).next('ul')
        ul.find('li').each (idx2, elem2) ->
          element = $(elem2)
          urn = element.find('a').text()
          url = "//#{urn}.herokuapp.com/g5_ops/health"
          ver = element.find('.version')
          $.ajax url,
            method: 'GET'
            success: (res, status, xhr) ->
              version = if res.version then res.version else res.health.version
              if version == master_version
                klass = 'current'
              else if version > master_version
                klass = 'ahead'
              else if version < master_version
                klass = 'behind'
              ver.html("<b class='#{klass}'>#{version}</b>")
            error: (xhr, status, err) ->
              ver.html("<b class='error'>not found</i>")

