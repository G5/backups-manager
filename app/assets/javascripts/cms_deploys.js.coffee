# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( () ->
  $(".cms-deploys-form input[type='submit']").click( () ->
    $(".cms-deploys-form input[type='submit']").hide()
    $("p.post-deploy-message").fadeIn()
  )

  new PusherListener
)

class PusherListener
  constructor: () ->
    if $('#pusher-config').length
      @configs = JSON.parse($('#pusher-config').html())
      @pusher = new Pusher('fdda70c3d83954241af5', { encrypted: true })
      @channel = @pusher.subscribe("#{@configs.channel}")

      that = this
      @channel.bind('my_event', (data) -> 
        that.taskCompleted(data)
      )

  taskCompleted: (data) ->
    appWrapper = $("li.#{data.app}")
    successClass = if data.activity == "Failed" then "failed-task" else "successful-task"
    appWrapper.append("<span class='finished-task #{successClass}'>#{data.activity}</span>")



