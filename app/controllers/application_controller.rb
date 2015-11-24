class ApplicationController < ActionController::Base
  include G5Authenticatable::Authorization
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  ADMIN_USERS = ["john.lucia@getg5.com"]

  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def verify_admin
    if ADMIN_USERS.include?(current_user.email)
      true
    else
      render :nothing => true, :status => 403
    end
  end

  def get_redis_data(key, error_message="Data is currently unavailable.")
    ($redis.get(key) && JSON.parse($redis.get(key)).present?) ? Hash[data: JSON.parse($redis.get(key)), error_status: false] : Hash[error_status: true, error_message: error_message]
  end

  def get_g5ops_data(key)
    ops_health_hash = {}
    if get_redis_data(key).is_a?(Array)
      ops_health_hash[:unhealthy_apps] = get_redis_data(key)
      ops_health_hash[:unhealthy_apps_count] = ops_health_hash[:unhealthy_apps].count
      ops_health_hash[:error_status] = false
    else
      ops_health_hash[:error_status] = true
      ops_health_hash[:error_message] =  "Data is currently unavailable."
      ops_health_hash[:unhealthy_apps] = get_redis_data(key)
    end
  end
end
