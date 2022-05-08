module Especialista::V1
    class RoomsController < ApiController
    before_action :load_room, only: [:show]
      
    def index
     permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
     @loading_service = Admin::ModelLoadingService.new(Room.all, permitted)
     @loading_service.call
    end

    def show; end

    private

    def load_room
      @room = Room.find(params[:id]) 
    end
  end
end
