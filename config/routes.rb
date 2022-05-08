Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    namespace :v1 do
      resources :users
      resources :rooms
      resources :consults
      resources :booked
    end
  end

  namespace :storefront do
    namespace :v1 do
      resources :rooms
      resources :room_rents
      get "/consults/:room_rent_id/validations", to: "consults_validations#index"
      resources :address
      resources :consults
      resources :booked
    end
  end

  namespace :especialista do
    namespace :v1 do
      resources :rooms
      resources :room_rents
      get "/rooms_rent/:room_id/booked", to: "booking_validations#index"
      resources :booked
    end
  end
  
end
