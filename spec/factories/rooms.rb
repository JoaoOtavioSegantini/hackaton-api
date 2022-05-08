FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 35) }
    price { Faker::Commerce.price(range: 800.0..10000.0) }
    avaliable { true }
  end
end
