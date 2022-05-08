FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      password { "123456" }
      password_confirmation { "123456" }
      profile { :admin }
      whatsapp_avaliable { Faker::Boolean.boolean }
      phone { Faker::PhoneNumber.cell_phone_in_e164 }
    end
  end