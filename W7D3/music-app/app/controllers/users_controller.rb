class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.new(strong_params)

    if user.save
      flash[:errors] = user.errors.full_messages unless self.login(user)

      redirect_to :root
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  private
  def strong_params
    params.require(:user).permit(:email, :password)
  end
end
