class CreateBusinessYears < ActiveRecord::Migration
  def change
    create_table :business_years do |t|
      t.string :year
      t.date :closed_on
      t.timestamps
    end
  end
end
