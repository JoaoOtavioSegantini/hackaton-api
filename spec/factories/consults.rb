FactoryBot.define do
  factory :consult do
    started_at {  3.days.from_now }
    finish_at {  6.days.from_now }
    user
    room_rent
  end
end
