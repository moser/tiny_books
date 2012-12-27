require 'spec_helper'

describe Account do
  it { should have_many :from_bookings }
  it { should have_many :to_bookings }

  it { should validate_presence_of :number }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :number }
  it { should validate_uniqueness_of :name }
  it { should ensure_inclusion_of(:kind).in_array %w(active passive) }
  
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

  describe "#balance_f" do
    it "returns a float value" do
      account = FG.create(:account)
      FG.create(:booking, to_account: account, value: 1000)
      account.balance_f.should == 10.00
    end
  end

  describe "#bookings" do
    it "returns all the bookings for the account" do
      account = FG.create(:account)
      FG.create(:booking, from_account: account, value: 1000)
      FG.create(:booking, to_account: account, value: 10000)
      account.bookings.length.should == 2
    end
  end
end
