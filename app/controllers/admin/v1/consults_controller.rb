module Admin::V1
  class ConsultsController < ApiController
    before_action :load_consult, only: [:update, :destroy, :show]

    def index
      @consults = Consult.all
    end

    def create
      @consult = Consult.new
      @consult.attributes = consult_params
      save_consult!
    end

    def show; end

    def update
      @consult.attributes = consult_params
      save_consult!
    end

    def destroy
      @consult.destroy!
    rescue
      render_error(fields: @consult.errors.messages)
    end

    private

    def save_consult!
        @consult.save!
        render :show
      rescue
        render_error(fields: @consult.errors.messages)
    end

    def consult_params
        return {} unless params.has_key?(:consult)
        params.require(:consult).permit(
            :id, :started_at, :finish_at, :user_id, :room_rent_id,
            payment_attributes: [:amount, :method, :date]
          )
    end

    def load_consult
      @consult = Consult.find(params[:id]) 
    end
  end
end
