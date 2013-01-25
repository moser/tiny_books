require 'spec_helper'

describe BookingTemplate do
  it { should validate_presence_of :name }
  it { should validate_presence_of :booking_type }
  it { should validate_presence_of :json }

  #it { validates_inclusion_of :booking_type, in: ["Booking", "BookingWithVat"] }
end
