# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  root 'tasks#index'

  resources :tasks
  post 'tasks/:id/toggle', to: 'tasks#toggle'
end
