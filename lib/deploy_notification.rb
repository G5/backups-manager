class DeployNotification

  def initialize(app, activity, channel='test_channel')
    Pusher.trigger(channel, 'my_event', {
      app: app,
      activity: activity
    })
  end

end