# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'home#index'
  resources :habit_types
  resources :habits do
    member do
      patch :toggle_availability
    end
  end
  resources :daily_habits do
    member do
      patch :mark_done
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
