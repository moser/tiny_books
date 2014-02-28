class BookingWithVatsController < ApplicationController
  before_filter :authenticate_user!

  def new
    new_booking_date = Booking.reorder(:created_at).last.try(:booking_date) || Date.today
    @booking = BookingWithVat.new(booking_date: new_booking_date)
    @accounts = Account.all
    @business_years = BusinessYear.where(closed_on: nil)
    @bookings = Booking.parents_only.reorder("created_at DESC")
    @booking_templates = BookingTemplate.all
  end

  def create
    @booking = BookingWithVat.new(params[:booking_with_vat])
    if @booking.save
      redirect_to new_booking_with_vat_path
    else
      @accounts = Account.all
      @business_years = BusinessYear.where(closed_on: nil)
      @bookings = Booking.parents_only.reorder("created_at DESC")
      @booking_templates = BookingTemplate.all
      render action: :new
    end
  end

  def import
    if params[:file_with_vat]
      BookingWithVat.import(params[:file_with_vat])
      redirect_to bookings_path, notice: "Import: OK"
    else
      redirect_to bookings_path
    end
  end
end
