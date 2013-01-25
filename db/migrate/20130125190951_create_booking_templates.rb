class CreateBookingTemplates < ActiveRecord::Migration
  def change
    create_table :booking_templates do |t|
      t.string :name
      t.string :booking_type
      t.string :json
      t.timestamps
    end
  end
end
