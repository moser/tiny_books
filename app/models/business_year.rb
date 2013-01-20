class BusinessYear < ActiveRecord::Base
  attr_accessible :year
  belongs_to :closed_to_business_year, class_name: BusinessYear

  has_many :bookings

  has_one :business_year_closed_to_this, class_name: BusinessYear, foreign_key: "closed_to_business_year_id"

  scope :open, where(closed_on: nil, closed_to_business_year_id: nil)

  def close(new_year)
    Account.all.each do |account|
      account.close(self, new_year)
    end
    self.closed_on = Date.today
    self.closed_to_business_year = new_year
    save
  end

  def to_s
    year.to_s
  end
end
