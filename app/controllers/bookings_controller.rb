class BookingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bookings = Booking.parents_only
    respond_to do |f|
      f.html
      f.pdf do 
        render pdf: "journal",
               formats: [:html],
               disable_internal_links: true,
               disable_external_links: true,
               dpi: "90"
      end
    end
  end

  def index_by_account
    @accounts = Account.all.select { |account| account.bookings.count > 0 }
    respond_to do |f|
      f.html
      f.pdf do 
        render pdf: "account-sheets",
               formats: [:html],
               disable_internal_links: true,
               disable_external_links: true,
               dpi: "90"
      end
    end
  end

  def new
    new_booking_date = Booking.reorder(:created_at).last.try(:booking_date) || Date.today
    @booking = Booking.new(booking_date: new_booking_date)
    @accounts = Account.all
    @business_years = BusinessYear.where(closed_on: nil)
    @bookings = Booking.parents_only.reorder("created_at DESC")
    @booking_templates = BookingTemplate.all
  end


  def create
    @booking = Booking.create(params[:booking])
    if @booking.valid?
      redirect_to new_booking_path
    else
      @accounts = Account.all
      @business_years = BusinessYear.where(closed_on: nil)
      @bookings = Booking.parents_only.reorder("created_at DESC")
      @booking_templates = BookingTemplate.all
      render action: :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
    redirect_to @booking.parent_booking if @booking.parent_booking
  end

  def revert
    @booking = Booking.find(params[:id])
    @booking.revert
    redirect_to @booking
  end

  def import
    if params[:file]
      Booking.import(params[:file])
      redirect_to bookings_path, notice: "Import: OK"
    else
      redirect_to bookings_path
    end
  end
end
