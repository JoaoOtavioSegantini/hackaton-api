module Storefront::V1
  class AddressController < ApiController
    before_action :load_address, only: [:update, :destroy, :show]

    def create
      @address = Address.new
      @address.attributes = address_params
      @address.user_id = @current_user.id
      save_address!  
    end

    def show; end

    def update
      @address.attributes = address_params
      save_address!
    end

    def destroy
      @address.destroy!
    rescue
      render_error(fields: @address.errors.messages)
    end

    private

    def load_address
     # @address = Address.find(params[:id])
     @address = Address.where(user: params[:id]).first
    end

    def address_params
      return {} unless params.has_key?(:address)
      params.require(:address).permit(
          :id, :street, :number, :complement, :city, 
          :state, :country, :zipcode, :user_id
        )
    end

    def save_address!
      @address.save!
      render :show
    rescue
      render_error(fields: @address.errors.messages)
    end
  end
end
