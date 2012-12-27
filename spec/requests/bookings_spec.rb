require "spec_helper"

describe "The bookings page" do
  it "shows me all bookings" do
    3.times { FG.create(:booking) }
    visit bookings_path
    status_code.should == 200
    all(:css, "tr.booking").length.should == 3
  end
end

describe "The new booking page" do
  before do
    FG.create(:account, number: 1000, name: "Bank")
    FG.create(:account, number: 4001, name: "Aufwandskonto")
  end

  it "makes enter all the data" do
    visit new_booking_path
    click_button "Create Booking"
    page.should have_content("can't be blank")
  end

  it "lets me create a new booking" do
    visit bookings_path
    click_link "New"
    fill_in "Voucher number", with: "10"
    select "Bank", from: "From account"
    select "Aufwandskonto", from: "To account"
    fill_in "Text", with: "Foo"
    fill_in "Value", with: "100.22"
    click_button "Create Booking"
    Booking.first.from_account.number.should == 1000
    Booking.first.to_account.number.should == 4001
    Booking.first.value.should == 10022
  end
end
