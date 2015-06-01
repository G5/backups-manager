# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  appsList = ['cms', 'dsh']
  $(appsList).each (i, app) ->
    $(".app-title##{app}").each (idx, elem) ->
      master_version = $(elem).find('.version-value').text()
      ul = $(elem).next('ul')
      ul.find('li').each (idx2, elem2) ->
        element = $(elem2)
        urn = element.find('a').text()
        url = "//#{urn}.herokuapp.com/g5_ops/health"
        ver = element.find('.version')
        $.ajax url,
          method: 'GET'
          success  : (res, status, xhr) ->
            version = if res.version then res.version else res.health.version
            if version == master_version
              klass = 'current'
            else if version > master_version
              klass = 'ahead'
            else if version < master_version
              klass = 'behind'
            ver.html("<b class='#{klass}'>#{version}</b>")
          error    : (xhr, status, err) ->
            ver.html("<b class='error'>not found</i>")
