class Account < ActiveRecord::Base
  Kinds = %w(active member expense revenue)

  attr_accessible :number, :name, :kind

  has_many :from_bookings, class_name: Booking, foreign_key: "from_account_id"
  has_many :to_bookings, class_name: Booking, foreign_key: "to_account_id"

  validates_presence_of :number
  validates_presence_of :name

  validates_uniqueness_of :number
  validates_uniqueness_of :name

  validates_inclusion_of :kind, in: Kinds 

  default_scope order('number ASC')

  def balance(year = nil)
    to_bookings(year).map(&:value).sum - from_bookings(year).map(&:value).sum    
  end

  def balance_f(year = nil)
    balance(year).to_f / 100.0
  end

  def from_bookings_with_year(year = nil)
    if year
      from_bookings_without_year.where(business_year_id: year.id)
    else
      from_bookings_without_year.where(business_year_id: BusinessYear.open.map(&:id))
    end
  end
  alias_method_chain :from_bookings, :year

  def to_bookings_with_year(year = nil)
    if year
      to_bookings_without_year.where(business_year_id: year.id)
    else
      to_bookings_without_year.where(business_year_id: BusinessYear.open.map(&:id))
    end
  end
  alias_method_chain :to_bookings, :year

  def bookings(year = nil)
    (from_bookings(year) + to_bookings(year)).sort_by(&:booking_date)
  end

  def close(year, new_year)
    if %(active member).include?(kind)
      from, to = Account.opening_account, self
      from, to = to, from if balance < 0
      Booking.create(business_year: new_year, voucher_number: "0", from_account: from, to_account: to,
                     value: balance(year).abs, text: "Opening")
    end
  end

  def to_s
    "#{number} #{name}"
  end

  def self.opening_account
    Account.where(name: "Opening").first || Account.create(name: "Opening", kind: "expense", number: "999999")
  end
end
