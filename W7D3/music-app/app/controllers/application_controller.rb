class String
  def to_russian
    #АБСДЭФГХИЈКЛМНОПQРЅТУВВЖЇЗ
    hash = ('A'..'Z').to_a.zip('АБСДЭҒГНIЈКЛМИОПQЯЅТЦЏШЖУЗ'.split('')).to_h
    upper = self.upcase

    upper.each_char.with_index { |ch, i| upper[i] = hash[ch] if hash[ch] }

    upper
  end
end

class ApplicationController < ActionController::Base
  helper_method :curr_user

  def curr_user
    @curr_user ||= User.find_by_session_token(session[:session_token])
  end

  def login(user)
    if self.logged_in?
      @current_user.errors[:account] << 'Already logged in!'
      return false
    end

    @curr_user = user
    session[:session_token] = self.curr_user.reset_session_token!
  end

  def logged_in?
    !!self.curr_user
  end

  def logout
    return false unless self.logged_in?

    self.curr_user.reset_session_token!
    session[:session_token] = nil
    @curr_user = nil

    true
  end

  private
  def require_log_in
    
    unless self.logged_in?
      flash[:errors] = ["Log in needed"]
      redirect_to new_session_url 
    end
  end
end
