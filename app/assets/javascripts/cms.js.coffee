$(document).ready ->
  cmsReady()
$(document).on 'page:load', ->
  cmsReady()

cmsReady = ->
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
  cmsMaster: "https://g5-cms-master.herokuapp.com"

  constructor: ()->
    @cms = $('.cms')
    @cmsCount = @cms.find('.app-item').length
    @initForm()
    @initSelectField('widgets', @widgetInput)
    @initSelectField('web_themes', @themeInput)
    @initResultStats()

  ## Initializer Functions

  openCmsList: ()->
    title = @cms.find('.app-title')
    title.addClass('show')
    title.next('.app-list').addClass('show')

  initForm: ()->
    @form = @cms.find('#cms-search-form')
    @typeInput = @cms.find('#target-type')
    @verticalInput = @cms.find('#target-vertical')
    @themeInput = @cms.find('#target-theme')
    @widgetInput = @cms.find('#target-widget')
    @statusInput = @cms.find('#target-status')
    @submit = @cms.find('#cms-search-submit')
    @submit.on 'click', ((e)=>
      @doAjax()
      window.noEvent(e)
    )

  initSelectField: (garden, elem)->
    $.ajax "#{@cmsMaster}/garden_#{garden}.json",
      method: 'GET'
      success: (res, status, xhr)=>
        str = "<option value=''>[select a #{garden.replace('_',' ').slice(0,-1)}]</option>"
        $.each res["garden_#{garden}"], ((idx, g)=>
          str += "<option value='" + g['slug'] + "'>" + g['name'] + "</option>"
        )
        elem.html(str)
      error: (xhr, status, err)=>
        elem.html("<option value=''>NOT FOUND</option>")

  ## AJAX Functions
  doAjax: ()->
    @resetCmsRows()
    @resetResultStats()
    @openCmsList()
    @cmsList().each (idx, elem)=>
      @appConfigAjax($(elem))

  appConfigAjax: (elem)->
    @incCmsSent()
    @setSearchResults(elem, '...')
    $.ajax @cmsConfigUrl(@getAppName(elem)),
      method: 'GET'
      success: (res, status, xhr)=>
        @ajaxSuccess(res, elem)
      error: (xhr, status, err)=>
        @ajaxError(elem)
      complete: (xhr, status)=>
        @incCmsReturned()

  ajaxSuccess: (results, elem)->
    if @isValidResults(results)
      @findSearchResults(results, elem)
    else
      @ajaxError(elem)

  ajaxError: (elem)->
    @setCmsNotFound(elem)
    @setSearchResults(elem, "<b class='error'>not set up</i>")

  ## Search Results Functions

  isValidResults: (results)->
    return results['client'] && results['locations'] && !results['client']['original_exception'] && !results['locations']['original_exception']

  findSearchResults: (results, elem)->
    @addLocationCount(results['locations'])
    locations = @filterByTypeAndVertical(results)
    locations = @filterByStatus(locations)
    locations = @filterByTheme(locations)
    locations = @filterByWidget(locations)
    @parseSearchResults(locations, elem)

  parseSearchResults: (locations, elem)->
    results = []
    $.each locations, (idx, res)=>
      results.push(res)
    if results.length
      @incCmsFound()
      @setSearchFoundResults(results, elem)
    else
      @setSearchNotFoundResults(elem)

  filterByTypeAndVertical: (results)->
    client = results['client']
    type = @getTypeValue()
    vert = @getVerticalValue()
    isValid = true
    if type != 'all'
      if (type == 'real' && client['g5_internal']) || (type == 'internal' && !client['g5_internal'])
        isValid = false
    if vert != 'all' && vert != client['vertical_slug']
      isValid = false
    return if isValid then results['locations'] else []

  filterByStatus: (locations)->
    status = @getStatusValue()
    return locations unless status.length
    return locations.filter (l)->
      l_status = l['status'].toLowerCase()
      if status == 'live no deploy'
        return l_status == 'live' || l_status == 'no deploy'
      else
        return l_status == status

  filterByTheme: (locations)->
    theme = @getThemeValue()
    return locations unless theme.length
    return locations.filter (l)->
      return l['theme_slug'] == theme

  filterByWidget: (locations)->
    widget = @getWidgetValue()
    return locations unless widget.length
    return locations.filter (l)->
      return $.inArray(widget, l['garden_widget_slugs']) != -1

  setSearchFoundResults: (resultSet, elem)->
    html = ""
    if resultSet.length
      $.each resultSet, (idx, res)=>
        @incLocationFound()
        html += @formatSearchFoundResults(elem, res)
    @setSearchResults(elem, "<ul>#{html}</ul>")
    @setCmsFound(elem)

  setSearchNotFoundResults: (elem)->
    @setSearchResults(elem, "<b class='error'>No matches found</b>")
    @setCmsNotFound(elem)

  setSearchResults: (elem, html)->
    elem.find('.search-results').html(html)

  formatSearchFoundResults: (elem, res)->
    url = @searchResultsUrl(elem, res['location_slug'])
    link = "<a href='#{url}' target='_blank'>#{res['location']} (#{res['urn']})</a>"
    extras = if @hasWidgetValue() then @formatWidgetsFoundResults(elem, res) else ''
    "<li class='success'>#{link}#{extras}</li>"

  formatWidgetsFoundResults: (elem, res)->
    results = ""
    $.each res['page_configs'], (idx, config)=>
      if @hasGardenWidget(config, @getWidgetValue())
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

  ## Target Accessors

  getTarget: (input)->
    $.trim(input.val()).toLowerCase()

  getTypeValue: ->
    @getTarget(@typeInput)

  getVerticalValue: ->
    @getTarget(@verticalInput)

  getStatusValue: ->
    @getTarget(@statusInput)

  getWidgetValue: ->
    @getTarget(@widgetInput)

  getThemeValue: ->
    @getTarget(@themeInput)

  hasWidgetValue: ->
    !!(@getWidgetValue().length > 0)

  ## Search Result Validation Functions

  hasGardenWidget: (res, widget)->
    $.inArray(widget, res['garden_widget_slugs']) != -1

  getAppName: (elem)->
    $.trim(elem.find('.app-name').text())

  ## CMS Row Accessor Functions

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

  resetResultStats: ()->
    @cmsSent = 0
    @cmsReturned = 0
    @cmsFound = 0
    @locationCount = 0
    @locationFound =  0
    @pageCount = 0
    @pageFound = 0
    if @hasWidgetValue()
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

  addLocationCount: (locations)->
    @locationCount += locations.length
    if @hasWidgetValue()
      $.each locations, (idx, l)=>
        @addToPageCount(l)
    @updateResultStats()

  incLocationFound: ->
    @locationFound += 1
    @updateResultStats()

  addToPageCount: (res)->
    @pageCount += if res['page_configs'] then res['page_configs'].length else 0
    @updateResultStats()

  incPageFound: ->
    @pageFound += 1
    @updateResultStats()
