class BookingWithVatsController < ApplicationController
  def new
    @booking = BookingWithVat.new
    @accounts = Account.all
  end

  def create
    @booking = BookingWithVat.new(params[:booking_with_vat])
    if @booking.save
      redirect_to @booking.parent_booking
    else
      @accounts = Account.all
      render action: :new
    end
  end
end
