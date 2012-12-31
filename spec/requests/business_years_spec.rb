require "spec_helper"

describe "The business years index page" do
  it "shows me all the business years" do
    FG.create(:business_year)
    FG.create(:business_year)
    visit business_years_path
    status_code.should == 200
    all(:css, "tr.business_year").size.should == 2
  end
end
