class Account < ActiveRecord::Base
  Kinds = %w(active passive)

  attr_accessible :number, :name, :kind


  has_many :from_bookings, class_name: Booking, foreign_key: "from_account_id"
  has_many :to_bookings, class_name: Booking, foreign_key: "to_account_id"

  validates_presence_of :number
  validates_presence_of :name

  validates_uniqueness_of :number
  validates_uniqueness_of :name

  validates_inclusion_of :kind, in: Kinds 

  def balance
    to_bookings.map(&:value).sum - from_bookings.map(&:value).sum    
  end

  def balance_f
    balance.to_f / 100.0
  end

  def bookings
    (from_bookings + to_bookings).sort_by(&:booking_date)
  end
end
