# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  window.orgsController = new OrgsController if $('.app').hasClass('orgs')

class OrgsController
  constructor: ->
    @updateOrgsVersions()
    window.toggleAppsGroups()

  updateOrgsVersions: ->
    $(".app-title").each (idx, elem) ->
      ul = $(elem).next('ul')
      ul.find('li').each (idx2, elem2) ->
        element = $(elem2)
        ver = element.find('.version')
        if ver.length
          urn = element.find('a').text()
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

