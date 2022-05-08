# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cadastrando usuários..."

35.times do
    profile = [:admin, :paciente, :especialista].sample
    create(:user, profile: profile)
    user = User.last
    create(:address, user_id: user.id)
  end

puts "Cadastros de usuários concluído."

puts "Cadastrando salas..."

  150.times do
    bathroom = [true, false].sample
    airConditioned = [true, false].sample
    furnished = [true, false].sample
    internet = [true, false].sample
    bathroom = [true, false].sample

    create(:room, bathroom: bathroom, airConditioned: airConditioned, furnished: furnished, internet: internet)
  end

puts "Cadastros de salas concluído."


puts "Cadastrando salas com consultórios..."

  24.times do |n|
    room = Room.all.uniq.sample
    user = User.all.sample
    create(:room_rent, room_id: room.id, user_id: user.id, started_at: (n + 1).days.from_now, finish_at: (7 + n).days.from_now)
  end

puts "Cadastro terminado com sucesso!!"