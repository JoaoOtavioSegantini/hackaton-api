FactoryBot.define do
  factory :book do
    user 
    room 
    admin { false }
    accepted { false }
  end
end
