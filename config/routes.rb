Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "staticpages#top"
  get "contact", to: "staticpages#contact", as: "contact"
  get "terms", to: "staticpages#terms", as: "terms"
  get "privacy", to: "staticpages#privacy", as: "privacy"
  get "notices", to: "staticpages#notices", as: "notices"

  devise_scope :user do
    get "users/:id", to: "users/registrations#show", as: :user
    get "users/:id/edit", to: "users/registrations#edit", as: :edit_user
    patch "users/:id", to: "users/registrations#update", as: :update_user
  end

  resources :museums do
    member do
      delete :remove_image
    end

    collection do
      get :nearest
    end

    resources :reviews
    resources :notes
  end

  resources :lists do
    member do
      post :add_museum
      delete :remove_museum
    end
  end

  resources :users, only: [] do
    get "notes", to: "users#notes", as: :notes
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
