class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :booking_date
      t.integer :from_account_id
      t.integer :to_account_id
      t.string :text
      t.integer :value #cents (or the smallest unit your currency)
      t.timestamps
    end
  end
end
