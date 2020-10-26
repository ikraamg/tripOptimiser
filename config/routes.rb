# frozen_string_literal: true

Rails.application.routes.draw do
  resources :bookings
  post 'bookings/upload', to: 'bookings#csv_create'
  root 'bookings#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
