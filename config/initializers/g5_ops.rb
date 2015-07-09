G5Ops.setup do |config|
  #
  # Configuration currently includes:
  #
  # Registering HealthModules e.g.
  # config.health_service.register('Facebook API') do
  #   # Do some stuff here to check the health of your component.
  #   # If you return false or raise an exception or return an exception then you module will be considered 'unhealthy'
  #   # If you return nil, anything truthy or a String it will be considered healthy and the String will be displayed along side the health
  #   # Psuedocode
  #   return FacebookAPI.getFriends.status == 200
  # end

  # This is a standard HealthModule that will check your ability to connect to your DB
  # Comment this out if you do not want to report on the DB connection health
  # This assumes you are using ActiveRecord as your ORM
  config.health_service.register_module G5Ops::DatabaseHealthModule.new
end
