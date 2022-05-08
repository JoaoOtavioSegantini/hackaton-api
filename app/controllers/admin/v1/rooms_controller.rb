module Admin::V1
    class RoomsController < ApiController
      before_action :load_room, only: [:update, :destroy, :show]

        def create
          @room = Room.new
          @room.attributes = room_params
          save_room!  
        end

        def show; end

        def update
          @room.attributes = room_params
          save_room!
        end

        def destroy
          @room.destroy!
        rescue
          render_error(fields: @room.errors.messages)
        end

        private

        def load_room
          @room = Room.find(params[:id])
        end

        def room_params
          return {} unless params.has_key?(:room)
          params.require(:room).permit(
              :id, :name, :description, :price, :avaliable, 
              :internet, :airConditioned, :bathroom, :furnished, :roomCleaning
            )
        end

        def save_room!
          @room.save!
          render :show
        rescue
          render_error(fields: @room.errors.messages)
        end
    end
end
