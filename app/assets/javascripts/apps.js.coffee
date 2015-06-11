# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.appsList ||= ['cms', 'dsh']

window.toggleAppsGroups = ->
  $(".app-title").on 'click', ->
    if $(this).hasClass('show')
      $(this).removeClass('show')
      $(this).next('.app-list').removeClass('show')
    else
      $(this).addClass('show')
      $(this).next('.app-list').addClass('show')

window.ajaxVersion = (urn, master, elem)->
  url = "//#{urn}.herokuapp.com/g5_ops/health"
  $.ajax url,
    method: 'GET'
    success: (res, status, xhr) ->
      window.ajaxVersionSuccess(res, master, elem)
    error: (xhr, status, err) ->
      window.ajaxVersionError(elem)

window.ajaxVersionSuccess = (res, master, elem)->
  version = if res.version then res.version else res.health.version
  if version == master
    klass = 'current'
  else if version > master
    klass = 'ahead'
  else if version < master
    klass = 'behind'
  elem.find('.version-value').html("<b class='#{klass}'>#{version}</b>")

window.ajaxVersionError = (elem)->
  elem.find('.version-value').html("<b class='error'>not found</i>")

window.documentReady = ->
  if $('.app').hasClass('orgs')
    window.orgsController = new OrgsController
  else
    window.appsController = new AppsController unless $('.app').hasClass('orgs')


## fixes turbolinks document ready
$(document).on 'ready page:load', window.documentReady

class AppsController
  constructor: ->
    window.toggleAppsGroups()
    @updateAppsVersions()

  updateAppsVersions: ->
    $(".app-title").each (idx, elem) ->
      master = $(elem).find('.version-value')
      if master.length
        master = master.text()
        ul = $(elem).next('ul')
        ul.find('li').each (idx2, elem2) ->
          element = $(elem2)
          urn = element.find('.app-name a').text()
          ver = element.find('.version')
          window.ajaxVersion(urn, master, ver)


class OrgsController
  constructor: ->
    window.toggleAppsGroups()
    @updateOrgsVersions()

  updateOrgsVersions: ->
    $(".app-title").each (idx, elem) ->
      ul = $(elem).next('ul')
      ul.find('li').each (idx2, elem2) ->
        element = $(elem2)
        ver = element.find('.version')
        if ver.length
          urn = element.find('.app-name a').text()
          master = ver.find('.master-value').text()
          window.ajaxVersion(urn, master, ver)
