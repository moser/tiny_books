require 'spec_helper'

describe Account do
  it { should have_many :from_bookings }
  it { should have_many :to_bookings }

  it { should validate_presence_of :number }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :number }
  it { should validate_uniqueness_of :name }
  it { should ensure_inclusion_of(:kind).in_array %w(active member expense revenue) }
  
  describe "#balance" do
    it "is the sum of all bookings" do
      account = FG.create(:account)
      FG.create(:booking, from_account: account, value: 1000)
      FG.create(:booking, from_account: account, value: 10000)
      account.reload
      account.balance.should == -11000
      FG.create(:booking, to_account: account, value: 12000)
      FG.create(:booking, to_account: account, value: 122)
      account.reload
      account.balance.should == 1122
    end
  end

  describe "#balance(year)" do
    it "returns only the sum of the bookings of the given year" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year)
      FG.create(:booking, from_account: account, value: 1000, business_year: old_year)
      a = FG.create(:booking, from_account: account, value: 1000)
      b = FG.create(:booking, from_account: account, value: 10000)
      account.balance(year).should == -11000
    end
  end

  describe "#balance_f" do
    it "returns a float value" do
      account = FG.create(:account)
      FG.create(:booking, to_account: account, value: 1000)
      account.balance_f.should == 10.00
    end
  end

  describe "#from_bookings" do
    it "returns the from bookings of open years" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year, closed_on: Date.parse("2011-12-31"), closed_to_business_year: year)
      FG.create(:booking, from_account: account, value: 1000, business_year: old_year)
      a = FG.create(:booking, from_account: account, value: 1000)
      b = FG.create(:booking, from_account: account, value: 10000)
      account.from_bookings.should == [ a, b ]
    end
  end

  describe "#from_bookings(year)" do
    it "returns only the from bookings of the given year" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year)
      FG.create(:booking, from_account: account, value: 1000, business_year: old_year)
      a = FG.create(:booking, from_account: account, value: 1000)
      b = FG.create(:booking, from_account: account, value: 10000)
      account.from_bookings(year).should == [ a, b ]
    end
  end
  
  describe "#to_bookings" do
    it "returns the to bookings of open years" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year, closed_on: Date.parse("2011-12-31"), closed_to_business_year: year)
      FG.create(:booking, to_account: account, value: 1000, business_year: old_year)
      a = FG.create(:booking, to_account: account, value: 1000)
      b = FG.create(:booking, to_account: account, value: 10000)
      account.to_bookings.should == [ a, b ]
    end
  end

  describe "#to_bookings(year)" do
    it "returns only the to bookings of the given year" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year)
      FG.create(:booking, to_account: account, value: 1000, business_year: old_year)
      a = FG.create(:booking, to_account: account, value: 1000)
      b = FG.create(:booking, to_account: account, value: 10000)
      account.to_bookings(year).should == [ a, b ]
    end
  end

  describe "#bookings" do
    it "returns the bookings for the account from open business years" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year, closed_on: Date.parse("2011-12-31"), closed_to_business_year: year)
      FG.create(:booking, from_account: account, value: 1000, business_year: old_year)
      FG.create(:booking, from_account: account, value: 1000)
      FG.create(:booking, to_account: account, value: 10000)
      account.bookings.length.should == 2
    end
  end

  describe "#bookings(year)" do
    it "returns the bookings for a specific year" do
      account = FG.create(:account)
      year = FG.create(:business_year)
      old_year = FG.create(:business_year)
      a = FG.create(:booking, from_account: account, value: 1000, business_year: old_year)
      b = FG.create(:booking, from_account: account, value: 1000, business_year: year)
      c = FG.create(:booking, to_account: account, value: 10000, business_year: year)
      account.bookings(old_year).should == [ a ]
      account.bookings(year).should == [ b, c ]
    end
  end

  %w(active member).each do |kind|
    context "of kind #{kind}" do
      describe "#close" do
        it "creates a closing booking in order to have the balance in the new year" do
          account = FG.create(:account, kind: kind)
          year = FG.create(:business_year)
          new_year = FG.create(:business_year)
          FG.create(:booking, from_account: account, value: 1000, business_year: year)
          FG.create(:booking, to_account: account, value: 100, business_year: year)
          FG.create(:booking, to_account: account, value: 100, business_year: new_year)
          closing_booking = account.close(year, new_year)
          closing_booking.from_account.should == account
          closing_booking.value.should == 900
        end
      end
    end
  end

  %w(expense revenue).each do |kind|
    context "of kind #{kind}" do
      describe "#close" do
        it "does nothing" do
          account = FG.create(:account, kind: kind)
          year = FG.create(:business_year)
          new_year = FG.create(:business_year)
          FG.create(:booking, from_account: account, value: 1000, business_year: year)
          closing_booking = account.close(year, new_year)
          closing_booking.should be_nil
        end
      end
    end
  end
end
