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
end
