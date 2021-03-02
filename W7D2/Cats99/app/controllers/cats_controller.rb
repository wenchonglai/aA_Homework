class CatsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :edit, :update]
  before_action :require_ownership, only: [:edit, :update]

  def initialize
    @colors = Cat::COLORS
    @cat = Cat.new
    super
  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])

    if @cat#.save
      render :show
    else
      render "not-found", status: 404
      # render plain: "invalid cat!"
      # redirect_to cats_url #-> "99cats.com/cats"
    end
  end

  def new
    render :new
  end
  
  def create
    @cat = Cat.new(strong_params)
    @cat.user_id = self.current_user.id
    
    if @cat.save!
      redirect_to cat_url(@cat)
    else
      render :new
    end
  rescue => exception
    render :new
  end

  def edit
    @cat = Cat.find_by(id: params[:id])

    if @cat
      render :edit
    else
      render "not-found", status: 404
    end
  end

  def update
    @cat = Cat.find_by(id: params[:id])

    if @cat
      if @cat.update(strong_params)
        redirect_to cat_url(params[:id])
      else
        redirect_to edit_url(params[:id])
      end
    else
      render "not-found", status: 404
    end
  end

  def destroy
    @cat = Cat.find_by(id: params[:id])

    if @cat
      if @cat.destroy
        redirect_to cats_url
      else
        render json: @cat.errors.full_messages
      end
    else
      render "not-found", status: 404
    end
  end

  
  private
  def require_ownership
    has_ownership = self.current_user.cats.find_by(id: params[:id])
    redirect_to cats_url unless has_ownership
  end

  def strong_params
    params.require(:cat).permit(:name, :sex, :color, :birth_date, :description, :user_id, :url)
  end
end
