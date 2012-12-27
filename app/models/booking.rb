class Booking < ActiveRecord::Base
  attr_accessible :booking_date, :from_account, :to_account, :text, :value,
                  :from_account_id, :to_account_id, :value_f, :voucher_number

  belongs_to :from_account, :class_name => Account
  belongs_to :to_account, :class_name => Account

  validates_presence_of :booking_date
  validates_presence_of :from_account
  validates_presence_of :to_account
  validates_presence_of :text
  validates_presence_of :value
  validates_presence_of :voucher_number

  validates_numericality_of :value, greater_than_or_equal_to: 0


  default_scope { order("booking_date ASC") }

  def value_f
    self.value.to_f / 100.0
  end

  def value_f=(f)
    f = f.to_f unless Float === f
    i = (f * 100).to_i
    self.value = i
  end
end
