require "spec_helper"

describe BookingWithVat do
  include ActiveModel::Lint::Tests

  def model
    BookingWithVat.new
  end

  # Make sure that this behaves like an active model
  ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
    example m.gsub('_',' ') do
      send m
    end
  end

  it { should validate_presence_of :business_year_id }
  it { should validate_presence_of :booking_date } 
  it { should validate_presence_of :from_account_id } 
  it { should validate_presence_of :to_account_id } 
  it { should validate_presence_of :text }
  it { should validate_presence_of :value_f }
  it { should validate_presence_of :voucher_number }
  it { should validate_presence_of :vat_account_id }
  it { should validate_presence_of :vat_percentage }
 
  context "when saved" do 
    let(:booking) { booking = FG.build(:booking_with_vat, 
                                       from_account_id: (@from = FG.create(:account)).id,
                                       to_account_id: (@to = FG.create(:account)).id,
                                       vat_account_id: (@vat = FG.create(:account)).id,
                                       value_f: 1.19) }

    it "sets the value on both bookings" do
      booking.save
      booking.parent_booking.value_f.should == 1.00
      booking.child_booking.value_f.should == 0.19
    end

    it "sets the right accounts on the parent booking" do
      booking.save
      booking.parent_booking.from_account.should == @from
      booking.parent_booking.to_account.should == @to
    end

    context "for vat on input" do
      it "sets the right accounts on the child booking" do
        booking.vat_on_input = true
        booking.save
        booking.child_booking.from_account.should == @vat
        booking.child_booking.to_account.should == @to
      end
    end

    context "for vat" do
      it "sets the right accounts on the child booking" do
        booking.vat_on_input = false
        booking.save
        booking.child_booking.from_account.should == @from
        booking.child_booking.to_account.should == @vat
      end
    end
  end

  describe "#value_f" do
    it "converts values to float" do
      booking = FG.build(:booking_with_vat)
      booking.value_f = "1.19"
      booking.value_f.should == 1.19
    end
  end


  describe "#vat_percentage" do
    it "converts values to float" do
      booking = FG.build(:booking_with_vat)
      booking.vat_percentage = "0.01"
      booking.vat_percentage.should == 0.01
    end
  end

  describe ".l" do
    it "returns the human model name when called without argument" do
      BookingWithVat.l.should == "Booking with vat"
    end

    it "returns a human attribute name when called with an argument" do
      BookingWithVat.l(:value_f).should == "Value f"
    end
  end
end
