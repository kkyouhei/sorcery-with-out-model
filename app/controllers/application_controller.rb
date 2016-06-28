class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :require_login

  def current_user
    if session[:user]
      User.new(id: session[:user]["id"], email: session[:user]["email"])
    end
  end

  def auto_login(user, should_remember = false)
    session[:user] = user
  end

  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
