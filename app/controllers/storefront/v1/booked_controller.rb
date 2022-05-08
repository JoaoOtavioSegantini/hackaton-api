module Storefront::V1
  class BookedController < ApiController

    def index
        @booked = Book.all.where(user_id: @current_user.id).with_aggregates
     #   @booked = Book.all.where(user_id: @current_user.id).or(Book.where(recepient_id: @current_user.id)).with_aggregates
    end

  end
end
