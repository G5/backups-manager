# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( () ->
  $(".cms-deploys-form input[type='submit']").click( () ->
    $(".cms-deploys-form input[type='submit']").hide()
    $("p.post-deploy-message").fadeIn()
  )
)
