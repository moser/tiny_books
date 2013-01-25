class BookingTemplate < ActiveRecord::Base
  attr_accessible :name, :booking_type, :json

  validates_presence_of :name, :booking_type, :json
end
