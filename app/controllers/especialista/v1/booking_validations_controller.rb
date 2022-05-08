module Especialista::V1
  class BookingValidationsController < ApplicationController
    def index 
      @booking = RoomRent.where(room_id: params[:room_id]).select(:id, :started_at, :finish_at)
      @range = @booking.map { |booked|  (booked.started_at..booked.finish_at).to_a  }
      array = []
      @range = @range.each { |obj| obj.map { |item|  array.push(item) }.flatten.to_json } if @range.length() > 1
      @range = array.flatten if @range.length() > 1
      render :show
    end
  end
end
