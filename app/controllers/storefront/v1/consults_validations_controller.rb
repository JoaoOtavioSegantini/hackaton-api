module Storefront::V1
  class ConsultsValidationsController < ApiController
    def index 
      @consults = Consult.where(room_rent_id: params[:room_rent_id]).select(:id, :started_at, :finish_at)
      @range = @consults.map { |consult|  (consult.started_at.to_date..consult.finish_at.to_date).to_a }
      array = []
      @range = @range.each { |obj| obj.map { |item|  array.push(item) }.flatten.to_json } if @range.length() > 1
      @range = array.flatten if @range.length() > 1
      render :show
    end    
  end
end
