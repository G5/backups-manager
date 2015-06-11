# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.appsList ||= ['cms', 'dsh']

window.toggleAppsGroups = ->
  $(".app-title").each (i, title) ->
    $(title).on 'click', ->
      if $(title).hasClass('show')
        $(title).removeClass('show')
        $(title).next('.app-list').removeClass('show')
      else
        $(title).addClass('show')
        $(title).next('.app-list').addClass('show')

$(document).ready ->
  window.toggleAppsGroups()
  if $('.app').hasClass('orgs')
    window.orgsController = new OrgsController
  else
    window.appsController = new AppsController unless $('.app').hasClass('orgs')

class AppsController
  constructor: ->
    @updateAppsVersions()

  updateAppsVersions: ->
    $(".app-title").each (idx, elem) ->
      master_version = $(elem).find('.version-value')
      if master_version.length
        master_version = master_version.text()

        ul = $(elem).next('ul')
        ul.find('li').each (idx2, elem2) ->
          element = $(elem2)
          urn = element.find('.app-name a').text()
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
              ver.find('.version-value').html("<b class='#{klass}'>#{version}</b>")
            error: (xhr, status, err) ->
              ver.find('.version-value').html("<b class='error'>not found</i>")

class OrgsController
  constructor: ->
    @updateOrgsVersions()

  updateOrgsVersions: ->
    $(".app-title").each (idx, elem) ->
      ul = $(elem).next('ul')
      ul.find('li').each (idx2, elem2) ->
        element = $(elem2)
        ver = element.find('.version')
        if ver.length
          urn = element.find('.app-name a').text()
          url = "//#{urn}.herokuapp.com/g5_ops/health"
          master_version = element.find('.master-version')
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
              ver.find('.version-value').html("<b class='#{klass}'>#{version}</b>")
            error: (xhr, status, err) ->
              ver.find('.version-value').html("<b class='error'>not found</i>")

