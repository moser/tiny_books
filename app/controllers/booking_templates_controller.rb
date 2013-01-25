class BookingTemplatesController < ApplicationController
  respond_to :html

  def index
    @booking_templates = BookingTemplate.all
    respond_with(@booking_templates)
  end

  def show
    @booking_template = BookingTemplate.find(params[:id])
    respond_with(@booking_template)
  end

  def new
    @booking_template = BookingTemplate.new
    respond_with(@booking_template)
  end

  def edit
    @booking_template = BookingTemplate.find(params[:id])
  end

  def create
    @booking_template = BookingTemplate.new(params[:booking_template])
    @booking_template.save
    respond_with(@booking_template)
  end

  def update
    @booking_template = BookingTemplate.find(params[:id])
    @booking_template.update_attributes(params[:booking_template])
    respond_with(@booking_template)
  end

  def destroy
    @booking_template = BookingTemplate.find(params[:id])
    @booking_template.destroy
    respond_with(@booking_template)
  end
end
