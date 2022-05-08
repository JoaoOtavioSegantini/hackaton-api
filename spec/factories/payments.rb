FactoryBot.define do
  factory :payment do
    amount { Faker::Commerce.price(range: 20.0..1000.0) }
    sequence(:method) { |n| "Basic #{n}" }
    date { Date.today }
    consult
  end
end
