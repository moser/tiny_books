TinyBooks::Application.routes.draw do
  resources :bookings do
    get :index_by_account, on: :collection
    get :revert, on: :member
    post :import, on: :collection
  end
  resources :booking_with_vats
  resources :accounts
  resources :business_years do
    resources :bookings
  end

  match '/', to: 'bookings#index'
end
