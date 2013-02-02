class BusinessYearsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @business_years = BusinessYear.all
  end
end
