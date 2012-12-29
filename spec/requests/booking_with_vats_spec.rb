require "spec_helper"

describe "The new booking with VAT page" do
  before do
    FG.create(:account, number: 1000, name: "Bank")
    FG.create(:account, number: 4000, name: "Aufwandskonto")
    FG.create(:account, number: 5000, name: "VSt")
  end

  it "makes enter all the data" do
    visit new_booking_with_vat_path
    click_button "Create Booking"
    page.should have_content("can't be blank")
  end

  it "lets me create a booking with an additional booking for VAT" do
    visit new_booking_with_vat_path
    fill_in "Voucher number", with: "10"
    select "Aufwandskonto", from: "From account"
    select "Bank", from: "To account"
    fill_in "Text", with: "Foo"
    fill_in "Value", with: "12.00"
    select "VSt", from: "Vat account"
    fill_in "Vat percentage", with: "0.20"
    click_button "Create Booking with vat"
    parent = Booking.parents_only.first
    parent.value.should == 1000
  end
end
