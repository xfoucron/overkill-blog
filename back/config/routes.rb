# frozen_string_literal: true

Rails.application.routes.draw do
  scope 'api' do
    scope 'edge' do
      scope 'users' do
        post 'signup', to: 'users#create'
        delete 'destroy', to: 'users#destroy'
        patch 'admin/:user_id', to: 'users#admin'

        post 'login', to: 'sessions#create'
      end

      resources :posts
    end
  end
end
