class AddVoucherToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :voucher_number, :string, default: "", null: false
  end
end
