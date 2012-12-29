TinyBooks::Application.routes.draw do
  resources :bookings do
    get :index_by_account, on: :collection
  end
  resources :booking_with_vats
  resources :accounts
end
