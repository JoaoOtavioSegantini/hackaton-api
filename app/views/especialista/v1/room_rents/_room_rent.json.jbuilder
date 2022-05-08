json.id room_rent.id
json.price room_rent.price
json.description room_rent.description

json.user room_rent.user if room_rent.user.present?

json.room do
    json.id room_rent.room.id
    json.name room_rent.room.name
    json.price room_rent.room.price
end

