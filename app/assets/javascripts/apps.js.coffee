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
    if activeTitle.length
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
        _this.ajaxSuccess(res, master, elem, url)
      error: (xhr, status, err) ->
        _this.ajaxError(elem)

  ajaxSuccess: (res, master, elem, url)->

    # Accounting for old versions
    if(res.status)
      res = res.status
    else if(res.health && res.health.version)
      res = res.health

    version = res.version

    master = $.trim(master)

    health = if (res && res.health) then res.health.OVERALL.is_healthy else 'UNKNOWN'

    klass = 'current' if version == master
    klass = 'ahead' if version > master
    klass = 'behind' if version < master

    markup = "<b class='#{klass}'>#{version}</b>"
    if health != 'UNKNOWN'
      healthClass = if health then 'fa-smile-o healthy' else 'fa-frown-o unhealthy'
      markup += " <a href='#{url}' target='_blank'><i class='fa #{healthClass}'></i></a>"

    @setVersionValue(elem, markup)

  ajaxError: (elem)->
    @setVersionValue(elem, "<b class='error'>not found</i>")

  setVersionValue: (elem, html)->
    elem.find('.version-value').html(html)


class AppsController extends BaseController
  constructor: ->
    super()
    @updateVersions()
    $('.version-refresh').on 'click', (e)=>
      @updateVersions()
      window.noEvent(e)

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


window.noEvent = (e)->
  e.stopPropagation()
  e.preventDefault()
  false
