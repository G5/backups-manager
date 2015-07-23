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
    if @getTarget(@themeInput).length
      @cmsList().each (idx, elem)=>
        @fireAjax('web_themes', $(elem))

  widgetAjax: ()->
    if @getTarget(@widgetInput).length
      @cmsList().each (idx, elem)=>
        @fireAjax('widgets', $(elem))

  fireAjax: (type, elem)->
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
      @setSearchResults(elem, "<b class='error'>No matches found</b>")

  findWidgetSearchResults: (resultSet, elem)->
    results = []
    target = @getTarget(@widgetInput)
    $.each resultSet, (idx, res)=>
      if @hasGardenWidget(res, target)
        results.push(res)
    if results.length
      @setSearchFoundResults(results, elem)
    else
      @setSearchResults(elem, "<b class='error'>No matches found</b>")

  setSearchFoundResults: (resultSet, elem)->
    html = ""
    $.each resultSet, (idx, res)=>
      html += "<b class='success'>#{res['location']} (#{res['urn']})</b><br>"
    @setSearchResults(elem, html)

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