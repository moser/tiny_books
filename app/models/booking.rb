require 'csv'

class Booking < ActiveRecord::Base
  attr_accessible :booking_date, :from_account, :to_account, :text, :value,
                  :from_account_id, :to_account_id, :value_f, :voucher_number,
                  :parent_booking, :business_year, :business_year_id,
                  :from_account_number, :to_account_number

  belongs_to :from_account, class_name: Account
  belongs_to :to_account, class_name: Account
  belongs_to :parent_booking, class_name: Booking
  belongs_to :reverted_by_booking, class_name: Booking
  belongs_to :business_year

  has_many :child_bookings, class_name: Booking, foreign_key: "parent_booking_id"

  has_one :reverted_booking, class_name: Booking, foreign_key: "reverted_by_booking_id"

  validates_presence_of :business_year
  validates_presence_of :booking_date
  validates_presence_of :from_account
  validates_presence_of :to_account
  validates_presence_of :text
  validates_presence_of :value
  validates_presence_of :voucher_number

  validates_numericality_of :value, greater_than_or_equal_to: 0


  default_scope includes(:child_bookings).order("booking_date ASC")
  scope :parents_only, where(parent_booking_id: nil)

  def value_f
    self.value.to_f / 100.0
  end

  def value_f=(f)
    f = f.gsub(",", "." if String === f
    f = f.to_f unless Float === f
    i = (f * 100).round(0)
    self.value = i
  end

  def from_account_number
    from_account.try(:number)
  end

  def to_account_number
    to_account.try(:number)
  end

  def from_account_number=(n)
    self.from_account = Account.where(number: n).first
  end

  def to_account_number=(n)
    self.to_account = Account.where(number: n).first
  end

  def initialize(*args)
    super(*args)
    self.booking_date = Date.today unless self.booking_date
  end

  def revert(parent_booking = nil)
    unless reverted_by_booking
      self.reverted_by_booking = Booking.create(business_year: business_year,
                                           booking_date: booking_date,
                                           voucher_number: voucher_number,
                                           from_account: to_account,
                                           to_account: from_account,
                                           text: "Storno: #{text}",
                                           value: value,
                                           parent_booking: parent_booking)
      save
      child_bookings.each do |child_booking|
        child_booking.revert(reverted_by_booking)
      end
    end
  end

  def initialize(*args)
    super(*args)
    self.voucher_number = Booking.last_voucher_number if !voucher_number || voucher_number.blank?
    self.booking_date ||= Date.today
  end

  def self.last_voucher_number
    Booking.select(:voucher_number).map(&:voucher_number).sort.last || ""
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Booking.create! row.to_hash.merge(business_year_id: BusinessYear.open.first.try(:id))
    end
  end
end
