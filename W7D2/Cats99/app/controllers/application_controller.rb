class ApplicationController < ActionController::Base
  helper_method :current_user

  def initialize(*args)
    @cat_count = Cat.count
    super()
  end

  def require_logged_in
    redirect_to new_session_url unless self.logged_in?
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    session[:session_token] = @user.reset_session_token!
  end

  def logged_in?
    !!self.current_user
  end

  def logout!
    self.current_user.reset_session_token! if self.logged_in?
    session[:session_token] = nil
    @current_user = nil
  end
end
