require "spec_helper"

describe "The new booking with VAT page" do
  before do
    FG.create(:account, number: 1000, name: "Bank")
    FG.create(:account, number: 4000, name: "Aufwandskonto")
    FG.create(:account, number: 5000, name: "VSt")
    FG.create(:account, number: 6000, name: "Erfolgskonto")
    FG.create(:account, number: 5001, name: "USt")
    FG.create(:business_year)
  end

  it "makes enter all the data" do
    visit new_booking_with_vat_path
    click_button "Create Booking"
    page.should have_content("can't be blank")
  end

  it "lets me create a booking with an additional booking for VAT" do
    visit new_booking_with_vat_path
    fill_in "Voucher number", with: "10"
    select "4000 Aufwandskonto", from: "From account"
    select "1000 Bank", from: "To account"
    fill_in "Text", with: "Foo"
    fill_in "Value", with: "12.00"
    select "5000 VSt", from: "Vat account"
    fill_in "Vat percentage", with: "0.20"
    click_button "Create Booking with vat"
    parent = Booking.parents_only.first
    parent.value.should == 1000
  end

  it "lets me create a booking with an additional booking for VAT the other way round" do
    visit new_booking_with_vat_path
    fill_in "Voucher number", with: "10"
    select "1000 Bank", from: "From account"
    select "6000 Erfolgskonto", from: "To account"
    fill_in "Text", with: "Foo"
    fill_in "Value", with: "12.00"
    select "5001 USt", from: "Vat account"
    uncheck("Vat on input")
    fill_in "Vat percentage", with: "0.20"
    click_button "Create Booking with vat"
    parent = Booking.parents_only.first
    parent.value.should == 1000
    vat = parent.child_bookings.first
    vat.from_account.should == Account.where(number: 1000).first
    vat.to_account.should == Account.where(number: 5001).first
    vat.value.should == 200
  end
end
