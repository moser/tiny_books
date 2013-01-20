class BookingWithVatsController < ApplicationController
  def new
    @booking = BookingWithVat.new
    @accounts = Account.all
    @business_years = BusinessYear.where(closed_on: nil)
    @bookings = Booking.parents_only.order("created_at DESC")
  end

  def create
    @booking = BookingWithVat.new(params[:booking_with_vat])
    if @booking.save
      redirect_to @booking.parent_booking
    else
      @accounts = Account.all
      @business_years = BusinessYear.where(closed_on: nil)
      render action: :new
    end
  end
end
