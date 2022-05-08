json.consultsBooked do
    json.array! @booked, :accepted, :admin, :created_at, :id, :recepient_id, :room, :updated_at, :user
  end