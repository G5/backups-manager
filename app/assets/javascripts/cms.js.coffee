# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  new CmsReporter if $('.cms').length

class CmsReporter
  constructor: ()->
    @cms = $('.cms')
    @initThemeForm()
    @initWidgetForm()
    
  initThemeForm: ()->
    @themeForm = @cms.find('#target-theme-form')
    @themeInput = @themeForm.find('#target-theme')
    @themeSubmit = @themeForm.find('#target-theme-submit')
    @themeSubmit.on 'click', ((e)=>
      @themeAjax()
      window.noEvent(e)
    )

  initWidgetForm: ()->
    @widgetForm = @cms.find('#target-widget-form')
    @widgetInput = @widgetForm.find('#target-widget')
    @widgetSubmit = @widgetForm.find('#target-widget-submit')
    @themeSubmit.on 'click', ((e)=>
      @widgetAjax()
      window.noEvent(e)
    )

  themeAjax: ()->
    val = $.trim(@themeInput.val())
    if val.length
      @cmsList().each (idx, elem)=>
        @fireAjax('web_themes', $(elem))

  widgetAjax: ()->
    val = $.trim(@widgetInput.val())
    if val.length
      @cmsList().each (idx, elem)=>
        @fireAjax('widgets', $(elem))

  fireAjax: (type, elem)->
    _this = this
    appName = $.trim(elem.find('.app-name').text())
    $.ajax @cmsConfigUrl(appName),
      method: 'GET'
      success: (res, status, xhr) ->
        _this.ajaxSuccess(res, type, elem)
      error: (xhr, status, err) ->
        _this.ajaxError(elem)

  ajaxSuccess: (result, type, elem)->
    if result[type]
      debugger
    else
      @ajaxError(elem)

  ajaxError: (elem)->
    @setSearchResults(elem, "<b class='error'>not set up</i>")

  setSearchResults: (elem, html)->
    elem.find('.search-results').html(html)

  cmsList: ()->
    @cList ||= @cms.find('.app-list .app-item')

  cmsConfigUrl: (appName) ->
    "https://#{appName}.herokuapp.com/g5_ops/config"