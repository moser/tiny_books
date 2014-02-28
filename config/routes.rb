TinyBooks::Application.routes.draw do
  devise_for :users

  resources :booking_templates


  resources :bookings do
    get :index_by_account, on: :collection
    get :revert, on: :member
    post :import, on: :collection
  end
  resources :booking_with_vats do
    post :import, on: :collection
  end
  resources :accounts
  resources :business_years do
    resources :bookings
  end

  match '/', to: 'bookings#index'
end
