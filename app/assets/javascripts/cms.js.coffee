$(document).ready ->
  new CmsReporter if $('.cms').length

class CmsReporter
  cmsCount: 0
  cmsSent: 0
  cmsReturned: 0
  cmsFound: 0
  locationCount: 0
  locationFound: 0
  pageCount: 0
  pageFound: 0

  constructor: ()->
    @cms = $('.cms')
    @cmsCount = @cms.find('.app-item').length
    @initAppTitle()
    @initThemeForm()
    @initWidgetForm()
    @initStatusForm()
    @initResultStats()

  ## Initializer Functions

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

  initStatusForm: ()->
    @statusForm = @cms.find('#target-status-form')
    @statusInput = @statusForm.find('#target-status')
    @statusSubmit = @statusForm.find('#target-status-submit')
    @statusSubmit.on 'click', ((e)=>
      @statusAjax()
      window.noEvent(e)
    )
    @statusInput.on 'focus', =>
      @themeInput.val('')
      @widgetInput.val('')

  ## AJAX Functions

  themeAjax: ()->
    @doAjax(@themeInput, 'web_themes')

  widgetAjax: ()->
    @doAjax(@widgetInput, 'widgets')

  statusAjax: ()->
    @doAjax(@statusInput, 'status')

  doAjax: (input, type)->
    if @getTarget(input).length
      @resetCmsRows()
      @resetResultStats(type)
      @cmsList().each (idx, elem)=>
        @appConfigAjax(type, $(elem))

  appConfigAjax: (type, elem)->
    @incCmsSent()
    @setSearchResults(elem, '...')
    $.ajax @cmsConfigUrl(@getAppName(elem)),
      method: 'GET'
      success: (res, status, xhr)=>
        @ajaxSuccess(res, type, elem)
      error: (xhr, status, err)=>
        @ajaxError(elem)
      complete: (xhr, status)=>
        @incCmsReturned()

  ajaxSuccess: (result, type, elem)->
    res_slug = if type == 'status' then 'web_themes' else type
    if result[res_slug]
      @findSearchResults(result[res_slug], type, elem)
    else
      @ajaxError(elem)

  ajaxError: (elem)->
    @setCmsNotFound(elem)
    @setSearchResults(elem, "<b class='error'>not set up</i>")

  ## Search Results Functions

  findSearchResults: (resultSet, type, elem)->
    @parseSearchResults(resultSet, elem, @themeInput, @hasGardenTheme, type) if type == 'web_themes'
    @parseSearchResults(resultSet, elem, @widgetInput, @hasGardenWidget, type) if type == 'widgets'
    @parseSearchResults(resultSet, elem, @statusInput, @hasStatus, type) if type == 'status'

  parseSearchResults: (resultSet, elem, input, validator, type)->
    results = []
    target = @getTarget(input)
    $.each resultSet, (idx, res)=>
      @incLocationCount()
      @addToPageCount(res) if type == 'widgets'
      if validator(res, target)
        results.push(res)
    if results.length
      @incCmsFound()
      @setSearchFoundResults(results, elem, type, target)
    else
      @setSearchNotFoundResults(elem)

  setSearchFoundResults: (resultSet, elem, type, target)->
    html = ""
    $.each resultSet, (idx, res)=>
      @incLocationFound()
      html += @formatSearchFoundResults(elem, res, type, target)
    @setSearchResults(elem, "<ul>#{html}</ul>")
    @setCmsFound(elem)

  setSearchNotFoundResults: (elem)->
    @setSearchResults(elem, "<b class='error'>No matches found</b>")
    @setCmsNotFound(elem)

  setSearchResults: (elem, html)->
    elem.find('.search-results').html(html)

  formatSearchFoundResults: (elem, res, type, target)->
    url = @searchResultsUrl(elem, res['location_slug'])
    link = "<a href='#{url}' target='_blank'>#{res['location']} (#{res['urn']})</a>"
    extras = if type == 'widgets' then @formatWidgetsFoundResults(elem, res, target) else ''
    "<li class='success'>#{link}#{extras}</li>"

  formatWidgetsFoundResults: (elem, res, target)->
    results = ""
    $.each res['widget_page_configs'], (idx, config)=>
      if @hasGardenWidget(config, target)
        @incPageFound()
        url = @searchResultsUrl(elem, res['location_slug'], config['page_slug'])
        link = "<a href='#{url}' target='_blank'>#{config['page']}</a>"
        results += "<li>#{link}</li>" 
    "<ul>#{results}</ul>"

  searchResultsUrl: (elem, locationSlug="", pageSlug="")->
    url = "https://#{@getAppName(elem)}.herokuapp.com"
    url += "/#{locationSlug}" if locationSlug.length
    url += "/#{pageSlug}/edit" if pageSlug.length
    url

  ## Search Result Validation Functions

  hasGardenTheme: (res, target)->
    res['theme_slug'].toLowerCase() == target || res['theme'].toLowerCase() == target

  hasGardenWidget: (res, target)->
    ret = false
    $.each res['garden_widgets'], (idx, widget)->
      if !ret && widget.toLowerCase() == target
        ret = true
    return ret if ret
    $.each res['garden_widget_slugs'], (idx, slug)->
      if !ret && slug.toLowerCase() == target
        ret = true
    ret

  hasStatus: (res, target)->
    res['status'].toLowerCase() == target

  getAppName: (elem)->
    $.trim(elem.find('.app-name').text())

  ## CMS Row Accessor Functions

  getTarget: (input)->
    $.trim(input.val()).toLowerCase()

  cmsList: ->
    @cList ||= @cms.find('.app-list .app-item')

  cmsConfigUrl: (appName) ->
    "https://#{appName}.herokuapp.com/g5_ops/config"

  setCmsFound: (elem)->
    elem.removeClass('not-found').addClass('found')

  setCmsNotFound: (elem)->
    elem.removeClass('found').addClass('not-found')

  resetCmsRows: ->
    @cmsList().removeClass('found').removeClass('not-found').show()

  ## Statistics Functions

  initResultStats: ()->
    @cmsSearchResults = $('#cms-search-results')
    @percSentDiv = @cmsSearchResults.find(".percentage-sent")
    @percReturnedDiv = @cmsSearchResults.find(".percentage-returned")
    @clientsFoundSpan = @cmsSearchResults.find(".clients-found span")
    @locationsFoundSpan = @cmsSearchResults.find(".locations-found span")
    @pagesFoundSpan = @cmsSearchResults.find(".pages-found span")

  resetResultStats: (type)->
    @cmsSent = 0
    @cmsReturned = 0
    @cmsFound = 0
    @locationCount = 0
    @locationFound =  0
    @pageCount = 0
    @pageFound = 0
    if type == 'widgets'
      @pagesFoundSpan.parent('div').show()
    else 
      @pagesFoundSpan.parent('div').hide()
    @updateResultStats()

  updateResultStats: ->
    @cmsSearchResults.show()

    if @cmsReturned == @cmsCount
      @percReturnedDiv.addClass('done')
    else
      @percReturnedDiv.removeClass('done')

    @percSentDiv.css
      width: "#{(@cmsSent/@cmsCount)*100}%"
    @percReturnedDiv.css
      width: "#{(@cmsReturned/@cmsCount)*100}%"

    @clientsFoundSpan.html @percentLabel(@cmsFound, @cmsCount) 
    @locationsFoundSpan.html @percentLabel(@locationFound, @locationCount)
    @pagesFoundSpan.html @percentLabel(@pageFound, @pageCount)

  percentLabel: (found, total)->
    perc = ((found/total)*100) || 0
    "#{found} / #{total} (#{perc.toFixed(4)}%)"

  incCmsSent: ->
    @cmsSent += 1
    @updateResultStats()

  incCmsReturned: ->
    @cmsReturned += 1
    @updateResultStats()

  incCmsFound: ->
    @cmsFound += 1
    @updateResultStats()

  incLocationCount: ->
    @locationCount += 1
    @updateResultStats()

  incLocationFound: ->
    @locationFound += 1
    @updateResultStats()

  addToPageCount: (res)->
    @pageCount += res['widget_page_configs'].length
    @updateResultStats()

  incPageFound: ->
    @pageFound += 1
    @updateResultStats()
