require 'spec_helper'

describe Booking do
  it { should belong_to :from_account }
  it { should belong_to :to_account }

  it { should validate_presence_of :booking_date } 
  it { should validate_presence_of :from_account } 
  it { should validate_presence_of :to_account } 
  it { should validate_presence_of :text }
  it { should validate_presence_of :value }
  it { should validate_presence_of :voucher_number }

  it "validates the positivity of value" do
    FG.build(:booking, value: -1).should_not be_valid
  end

  describe "#value_f" do
    it "returns floats" do
      Booking.new(value: 122).value_f.should == 1.22
    end

    it "accepts floats" do
      booking = Booking.new
      booking.value_f = 12.22
      booking.value.should == 1222
    end
  end
end
