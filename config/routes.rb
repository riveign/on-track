# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  namespace :admin do
    resources :daily_habits
    resources :habits
    resources :habit_types
    resources :reminders
    resources :users

    root to: 'users#index'
  end
  devise_for :users
  telegram_webhook TelegramWebhooksController
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'home#index'
  get 'todays_reminders_and_habits', to: 'home#todays_reminders_and_habits'
  get 'list_all_habits', to: 'home#list_all_habits'
  get 'calendar', to: 'home#calendar'
  get 'new_reminder_or_habit', to: 'home#new_reminder_or_habit'
  get '/service_worker.js' => 'service_worker#service_worker'
  get '/manifest.json' => 'service_worker#manifest'
  resources :habit_types
  resources :habits
  resources :users, only: %i[edit update]
  resources :reminders do
    member do
      patch :mark_done
    end
  end
  resources :daily_habits do
    member do
      patch :mark_done
    end
  end
end
