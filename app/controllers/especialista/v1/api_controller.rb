module Especialista::V1
  class ApiController < ApplicationController
    class ForbiddenAccess < StandardError; end
    include Authenticatable

    include SimpleErrorRenderable
    self.simple_error_partial = "shared/simple_error"

    rescue_from ForbiddenAccess do 
      render_error(message: "Forbidden access", status: :forbidden)
    end
    
    before_action :restrict_access_for_especialista!

    private

    def restrict_access_for_especialista!
       raise ForbiddenAccess unless current_user.especialista?
    end
  end
end