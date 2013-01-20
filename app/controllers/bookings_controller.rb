class BookingsController < ApplicationController
  def index
    #TODO authorize
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
    #TODO authorize
    @booking = Booking.new
    @accounts = Account.all
    @business_years = BusinessYear.where(closed_on: nil)
    @bookings = Booking.parents_only.order("created_at DESC")
  end


  def create
    #TODO authorize
    @booking = Booking.create(params[:booking])
    if @booking.valid?
      redirect_to new_booking_path
    else
      @accounts = Account.all
      @business_years = BusinessYear.where(closed_on: nil)
      render action: :new
    end
  end

  def show
    #TODO authorize
    @booking = Booking.find(params[:id])
    redirect_to @booking.parent_booking if @booking.parent_booking
  end

  def revert
    #TODO authorize
    @booking = Booking.find(params[:id])
    @booking.revert
    redirect_to @booking
  end
end
