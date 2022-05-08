module Storefront::V1
  class RoomRentsController < ApiController
    before_action :load_rent, only: [:update, :destroy, :show]

    def index
      permitted = params.permit({ search: :title }, { order: {} }, :page, :length)
     # @loading_service = Admin::ModelLoadingService.new(RoomRent.all.with_aggregates, permitted)
      @loading_service = Admin::ModelLoadingService.new(RoomRent.all, permitted)
      @loading_service.call
    end

    def create
      @rent = RoomRent.new
      @rent.attributes = room_rent_params
      @rent.user_id = @current_user.id
      save_room_rent!
    end

    def show; end

    def update
      @rent.attributes = room_rent_params
      save_room_rent!
    end

    def destroy
      @rent.destroy!
    rescue
      render_error(fields: @rent.errors.messages)
    end

    private

    def save_room_rent!
        @rent.save!
        render :show
      rescue
        render_error(fields: @rent.errors.messages)
    end

    def room_rent_params
        return {} unless params.has_key?(:room_rent)
        params.require(:room_rent).permit(
            :id, :started_at, :finish_at, :user_id, :title,
            :room_id, :price, :description, :especialization
          )
    end

    def load_rent
      @rent = RoomRent.find(params[:id]) 
    end
  end
end
