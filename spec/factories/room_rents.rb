FactoryBot.define do
  factory :room_rent do
    started_at { 3.days.from_now }
    finish_at { 1.year.from_now }
    title { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph(sentence_count: 25) }
    especialization { Faker::Lorem.paragraph(sentence_count: 15) }
    user 
    room 
    price { Faker::Commerce.price(range: 20.0..1000.0) }
  end
end
