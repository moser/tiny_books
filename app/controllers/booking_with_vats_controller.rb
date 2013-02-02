class BookingWithVatsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @booking = BookingWithVat.new
    @accounts = Account.all
    @business_years = BusinessYear.where(closed_on: nil)
    @bookings = Booking.parents_only.order("created_at DESC")
  end

  def create
    @booking = BookingWithVat.new(params[:booking_with_vat])
    if @booking.save
      redirect_to new_booking_with_vat_path
    else
      @accounts = Account.all
      @business_years = BusinessYear.where(closed_on: nil)
      @bookings = Booking.parents_only.order("created_at DESC")
      render action: :new
    end
  end
end
