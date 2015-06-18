# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.documentReady = ->
  if $('.app').hasClass('orgs')
    window.orgsController = new OrgsController
  else
    window.appsController = new AppsController

## fixes turbolinks document ready
$(document).on 'ready page:load', window.documentReady

class BaseController
  constructor: ->
    @toggleAppsGroups()
    @appTitles = $(".app-title")
    @openHash()

  openHash: ->
    hash = window.location.hash
    activeTitle = $(".app-title#{hash}") if hash
    if activeTitle
      activeTitle.click()
      $('html, body').animate { scrollTop: activeTitle.offset().top }, 400

  toggleAppsGroups: ->
    $(".app-title").on 'click', ->
      if $(this).hasClass('show')
        $(this).removeClass('show')
        $(this).next('.app-list').removeClass('show')
      else
        $(this).addClass('show')
        $(this).next('.app-list').addClass('show')
        window.location.hash = $(this).attr('id')

  ajaxVersion: (urn, master, elem)->
    url = "//#{urn}.herokuapp.com/g5_ops/health"
    _this = this
    @setVersionValue(elem, "...")
    $.ajax url, 
      method: 'GET'
      success: (res, status, xhr) ->
        _this.ajaxSuccess(res, master, elem)
      error: (xhr, status, err) ->
        _this.ajaxError(elem)

  ajaxSuccess: (res, master, elem)->
    version = if res.version then res.version else res.health.version
    klass = 'current' if version == master
    klass = 'ahead' if version > master
    klass = 'behind' if version < master
    @setVersionValue(elem, "<b class='#{klass}'>#{version}</b>")

  ajaxError: (elem)->
    @setVersionValue(elem, "<b class='error'>not found</i>")

  setVersionValue: (elem, html)->
    elem.find('.version-value').html(html)

  noEvent: (e)->
    e.stopPropagation()
    e.preventDefault()
    false

class AppsController extends BaseController
  constructor: ->
    super()
    @updateVersions()
    $('.version-refresh').on 'click', (e)=>
      @updateVersions()
      @noEvent(e)

  updateVersions: ->
    @appTitles.each (idx, elem) =>
      master = $(elem).find('.version-value')
      if master.length
        master = master.text()
        ul = $(elem).next('ul')
        ul.find('li').each (idx2, elem2) =>
          urn = $(elem2).find('.app-name a').text()
          ver = $(elem2).find('.version')
          @ajaxVersion(urn, master, ver)


class OrgsController extends BaseController
  constructor: ->
    super()
    @updateVersions()

  updateVersions: ->
    @appTitles.each (idx, elem) =>
      ul = $(elem).next('ul')
      ul.find('li').each (idx2, elem2) =>
        element = $(elem2)
        ver = element.find('.version')
        if ver.length
          urn = element.find('.app-name a').text()
          master = ver.find('.master-value').text()
          @ajaxVersion(urn, master, ver)
