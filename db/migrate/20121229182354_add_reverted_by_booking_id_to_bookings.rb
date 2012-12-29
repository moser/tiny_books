class AddRevertedByBookingIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :reverted_by_booking_id, :integer
  end
end
