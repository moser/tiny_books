class BookingsController < ApplicationController
  def index
    #TODO authorize
    @bookings = Booking.all
  end

  def new
    #TODO authorize
    @booking = Booking.new
    @accounts = Account.all
  end


  def create
    #TODO authorize
    @booking = Booking.create(params[:booking])
    if @booking.valid?
      redirect_to new_booking_path
    else
      render action: :new
    end
  end
end
