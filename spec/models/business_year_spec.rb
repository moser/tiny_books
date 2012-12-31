require 'spec_helper'

describe BusinessYear do
  it { should belong_to :closed_to_business_year }

  it { should have_many :bookings }

  it { should have_one :business_year_closed_to_this }

  describe "#close" do #this is rather an integration test for the closing of a business year
    def booking(from, to, value)
      FG.create(:booking, from_account: from, to_account: to, value: value)
    end

    it "closes it to the given business year" do
      y11 = FG.create(:business_year, year: "2011")
      y12 = FG.create(:business_year, year: "2012")

      bank = FG.create(:account, kind: "active")
      expense = FG.create(:account, kind: "expense")
      member = FG.create(:account, kind: "member")
      
      booking(bank, member, 1000)
      booking(expense, bank, 200)

      y11.close(y12)

      bank.balance.should == -800
      expense.balance.should == 0
      member.balance.should == 1000
    end
  end
end
