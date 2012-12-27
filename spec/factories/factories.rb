require 'factory_girl'

FactoryGirl.define do
  factory :account do
    sequence(:number) { |n| n }
    sequence(:name) { |n| "Name #{n}" }
    kind "active"
  end

  factory :booking do
    booking_date { Date.today }
    association :from_account, factory: :account
    association :to_account, factory: :account
    text "foo"
    value 100
    voucher_number "12-1000"
  end
end
