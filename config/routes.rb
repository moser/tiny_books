TinyBooks::Application.routes.draw do
  resources :bookings
  resources :booking_with_vats
  resources :accounts
end
