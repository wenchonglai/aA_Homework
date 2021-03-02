class CatRentalRequestsController < ApplicationController
  def index
    debugger
    @requests = CatRentalRequest.find_by(cat_id: params[:id])

    render :index
  end

  def new
    @cats = Cat.all
    render :new
  end

  def create 
    @request = CatRentalRequest.new(strong_params)
    
    if @request.save
      redirect_to cat_rental_requests(@request.cat_id)
    else
      render :new
    end
  end

  private
  def strong_params
    params.require(:request).permit(:cat_id, :start_date, :end_date)
  end
end
