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

  factory :booking_with_vat do
    booking_date { Date.today }
    from_account_id { FG.create(:account).id }
    to_account_id { FG.create(:account).id }
    text "foo"
    value_f 119
    voucher_number "12-1000"
    vat_account_id { FG.create(:account).id }
    vat_percentage 0.19
    vat_on_input true
  end
end
