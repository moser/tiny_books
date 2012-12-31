class AddClosedToBusinessYearToBusinessYear < ActiveRecord::Migration
  def change
    add_column :business_years, :closed_to_business_year_id, :integer
  end
end
