Rails.application.routes.draw do
  resources :bookings
  post 'bookings/upload', :to => 'bookings#csv_create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
