class SessionsController < ApplicationController
  def new
    render :new
  end
  
  def create
    @user = User.find_with_password(strong_params)
    
    if @user
      if self.login(@user)
        redirect_to :root
      else
        flash.now[:errors] == @user.errors.full_messages
        render :new
      end
    else
      flash[:errors] = [ @user.nil? ? "User does not exist" : "Incorrect Password"]
      redirect_to new_user_url
    end
  end

  def destroy
    if self.logout
      redirect_to :root
    else
      flash[:errors] = [session[:session_token], "User does not exist or is not logged in!"]
      redirect_to :root
    end
  end

  private
  def strong_params
    params.require(:session).permit(:email, :password)
  end
end
