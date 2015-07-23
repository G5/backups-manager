# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  new CmsReporter if $('.cms').length

class CmsReporter
  constructor: ()->
    @cms = $('.cms')
    @initAppTitle()
    @initThemeForm()
    @initWidgetForm()

  initAppTitle: ()->
    title = @cms.find('.app-title')
    title.addClass('show')
    title.next('.app-list').addClass('show')
    
  initThemeForm: ()->
    @themeForm = @cms.find('#target-theme-form')
    @themeInput = @themeForm.find('#target-theme')
    @themeSubmit = @themeForm.find('#target-theme-submit')
    @themeSubmit.on 'click', ((e)=>
      @themeAjax()
      window.noEvent(e)
    )
    @themeInput.on 'keydown', =>
      @widgetInput.val('')

  initWidgetForm: ()->
    @widgetForm = @cms.find('#target-widget-form')
    @widgetInput = @widgetForm.find('#target-widget')
    @widgetSubmit = @widgetForm.find('#target-widget-submit')
    @widgetSubmit.on 'click', ((e)=>
      @widgetAjax()
      window.noEvent(e)
    )
    @widgetInput.on 'keydown', =>
      @themeInput.val('')

  getTarget: (input)->
    $.trim(input.val()).toLowerCase()

  themeAjax: ()->
    @doAjax(@themeInput, 'web_themes')

  widgetAjax: ()->
    @doAjax(@widgetInput, 'widgets')

  doAjax: (input, type)->
    if @getTarget(input).length
      @resetCmsRows()
      @cmsList().each (idx, elem)=>
        @appConfigAjax(type, $(elem))

  appConfigAjax: (type, elem)->
    @setSearchResults(elem, '...')
    appName = $.trim(elem.find('.app-name').text())
    $.ajax @cmsConfigUrl(appName),
      method: 'GET'
      success: (res, status, xhr)=>
        @ajaxSuccess(res, type, elem)
      error: (xhr, status, err)=>
        @ajaxError(elem)

  ajaxSuccess: (result, type, elem)->
    if result[type]
      @findSearchResults(result[type], type, elem)
    else
      @ajaxError(elem)

  ajaxError: (elem)->
    @setCmsNotFound(elem)
    @setSearchResults(elem, "<b class='error'>not set up</i>")

  findSearchResults: (resultSet, type, elem)->
    @findThemeSearchResults(resultSet, elem) if type == 'web_themes'
    @findWidgetSearchResults(resultSet, elem) if type == 'widgets'

  findThemeSearchResults: (resultSet, elem)->
    results = []
    target = @getTarget(@themeInput)
    $.each resultSet, (idx, res)->
      if res['slug'].toLowerCase() == target || res['theme'].toLowerCase() == target
        results.push(res)
    if results.length
      @setSearchFoundResults(results, elem)
    else
      @setSearchNotFoundResults(elem)

  findWidgetSearchResults: (resultSet, elem)->
    results = []
    target = @getTarget(@widgetInput)
    $.each resultSet, (idx, res)=>
      if @hasGardenWidget(res, target)
        results.push(res)
    if results.length
      @setSearchFoundResults(results, elem)
    else
      @setSearchNotFoundResults(elem)

  setSearchFoundResults: (resultSet, elem)->
    html = ""
    $.each resultSet, (idx, res)=>
      html += "<b class='success'>#{res['location']} (#{res['urn']})</b><br>"
    @setSearchResults(elem, html)
    @setCmsFound(elem)

  setSearchNotFoundResults: (elem)->
    @setSearchResults(elem, "<b class='error'>No matches found</b>")
    @setCmsNotFound(elem)

  hasGardenWidget: (res, target)->
    ret = false
    $.each res['garden_widgets'], (idx, widget)->
      if !ret && widget.toLowerCase() == target
        ret = true
    return ret if true
    $.each res['garden_widget_slugs'], (idx, slug)->
      if !ret && slug.toLowerCase() == target
        ret = true
    ret

  setSearchResults: (elem, html)->
    elem.find('.search-results').html(html)

  cmsList: ()->
    @cList ||= @cms.find('.app-list .app-item')

  cmsConfigUrl: (appName) ->
    "https://#{appName}.herokuapp.com/g5_ops/config"

  setCmsFound: (elem)->
    elem.removeClass('not-found').addClass('found')

  setCmsNotFound: (elem)->
    elem.removeClass('found').addClass('not-found')

  resetCmsRows: ->
    @cmsList().removeClass('found').removeClass('not-found').show()