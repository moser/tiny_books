class BusinessYearsController < ApplicationController
  def index
    @business_years = BusinessYear.all
  end
end
