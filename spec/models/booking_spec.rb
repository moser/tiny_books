require 'spec_helper'

describe Booking do
  it { should belong_to :from_account }
  it { should belong_to :to_account }
  it { should belong_to :parent_booking }
  it { should belong_to :reverted_by_booking }

  it { should have_many :child_bookings }

  it { should have_one :reverted_booking }

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

    it "rounds correctly" do
      booking = Booking.new
      booking.value_f = 0.189999999
      booking.value.should == 19
    end
  end

  describe "#revert" do
    it "creates a booking which eliminates the original one" do
      booking = FG.create(:booking)
      booking.revert
      reverting_booking = booking.reverted_by_booking
      reverting_booking.booking_date.should == booking.booking_date
      reverting_booking.voucher_number.should == booking.voucher_number
      reverting_booking.from_account.should == booking.to_account
      reverting_booking.to_account.should == booking.from_account
      reverting_booking.value.should == booking.value
      reverting_booking.text.should be_include(booking.text)
      reverting_booking.text.should be_include("Storno")
    end

    it "reverts existing child bookings" do
      booking = FG.create(:booking, value: 2000)
      child_booking = FG.create(:booking, parent_booking: booking, value: 1000)
      booking.reload
      booking.revert
      booking.from_account.balance.should == 0
      booking.to_account.balance.should == 0
      child_booking.from_account.balance.should == 0
      child_booking.to_account.balance.should == 0
    end

    it "makes the reverting bookings also parent and child" do
      booking = FG.create(:booking, value: 2000)
      child_booking = FG.create(:booking, parent_booking: booking, value: 1000)
      booking.reload
      booking.revert
      child_booking.reload
      child_booking.reverted_by_booking.parent_booking.should == booking.reverted_by_booking
    end

    it "cannot be reverted if already" do
      booking = FG.create(:booking)
      booking.revert
      booking.revert
      Booking.count.should == 2
    end
  end
end
