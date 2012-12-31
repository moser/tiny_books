class AddBusinessYearToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :business_year_id, :integer
  end
end
