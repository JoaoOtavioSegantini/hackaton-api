FactoryBot.define do
  factory :room_feature do
    internet { Faker::Boolean.boolean }
    airConditioned { Faker::Boolean.boolean }
    bathroom { Faker::Boolean.boolean }
    furnished { Faker::Boolean.boolean }
    roomCleaning { Faker::Boolean.boolean }
    room
  end
end
