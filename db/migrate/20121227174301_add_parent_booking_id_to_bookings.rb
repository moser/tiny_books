class AddParentBookingIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :parent_booking_id, :integer
  end
end
