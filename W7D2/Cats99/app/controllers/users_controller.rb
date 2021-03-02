class UsersController < ApplicationController
  def new
    #render sign up form
    render :new
  end
  
  def create
    #use data from sign up form to create a new user; 
    #log in
    #then redirect to the cats index page
    @user = User.create(strong_params)
    # p strong_params

    if @user.save!
      msg = UserMailer.welcome_email(@user)
      msg.deliver_now
      login!(@user)

      redirect_to cats_url
    else
      render :new
    end
  end

  private
  def strong_params 
    params.require(:user).permit(:username, :password, :email)
  end
end
