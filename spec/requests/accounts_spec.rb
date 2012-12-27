require "spec_helper"

describe "The accounts index" do
  it "shows me all the accounts" do
    3.times { FG.create(:account) }
    visit accounts_path
    status_code.should == 200
    all(:css, "tr.account").length.should == 3
  end
end

describe "The new accounts page" do
  it "lets me create a new account" do
    visit accounts_path
    click_link "New"
    status_code.should == 200
    fill_in "Number", with: 1001
    fill_in "Name", with: "Konto X"
    select "active", from: "Kind"
    click_button "Create Account"
    page.should have_content("Konto X")
    page.should have_content("1001")
  end

  it "makes me enter all the data" do
    visit new_account_path
    click_button "Create Account"
    page.should have_content("can't be blank")
  end
end

describe "The account page" do
  it "shows me all of the bookings" do
    account = FG.create(:account)
    FG.create(:booking, from_account: account, value: 1000)
    FG.create(:booking, to_account: account, value: 10000)
    visit account_path(account)
    page.should have_content(90.00)
    all(:css, "tr.booking").length.should == 2
  end
end
