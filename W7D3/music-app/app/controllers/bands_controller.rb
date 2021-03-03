class BandsController < ApplicationController
  before_action :require_log_in

  def initialize  
    super
    @band = Band.new
  end

  def index  
    @bands = Band.all
    render :index
  end

  def show
    @band = Band.find_by(id: params[:id])
    if @band
      render :show
    else
      redirect_to :new
    end
  end

  def new
    render :new
  end

  def create
    @band = Band.new(strong_params)

    if @band
      if @band.save
        redirect_to bands_url
      else
        flash.now[:errors] = @band.errors.full_messages
        render :new
      end
    else
      flash.now[:errors] = ["Unable to create band"]
      render :new
    end
  end

  def edit
    @band = Band.find_by(id: params[:id])
    render :edit
  end

  def update 
    @band = Band.find_by(id: params[:id])

    if @band
      if @band.update(strong_params)
        redirect_to band_url(params[:id])
      else
        flash.now[:errors] = @band.errors.full_messages
        render :edit
      end
    else
      flash.now[:errors] = ["Unable to update band"]
      render :edit
    end
  end

  def destroy
    @band = Band.find_by(id: params[:id])

    if @band
      if @band.destroy
        redirect_to bands_url
      else
        flash.now[:errors] = @band.errors.full_messages 
        render :show
      end
    else
      flash.now[:errors] = ["Unable to delete band"]
      render :show
    end

    
  end

  private
  def strong_params
    params.require(:band).permit(:name, :image_url)
  end
end
