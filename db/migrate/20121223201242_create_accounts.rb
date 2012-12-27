class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :number
      t.string :name
      t.string :kind #to avoid type
      t.timestamps
    end
  end
end
