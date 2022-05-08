module Especialista::V1
  class BookedController < ApiController
    before_action :load_book, only: [:update, :show]

    def index
        @booked = Book.all.where(recepient_id: @current_user.id).with_aggregates
    end

    def show; end

    def update
      @book.attributes = booking_params
      save_book!
    end

    private

    def save_book!
        @book.save!
        render :show
      rescue
        render_error(fields: @book.errors.messages)
    end

    def booking_params
        return {} unless params.has_key?(:book)
        params.require(:book).permit(:id, :accepted)
    end

    def load_book
      @book = Book.find(params[:id]) 
    end
  end
end
