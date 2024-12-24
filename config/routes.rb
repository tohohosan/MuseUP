Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  get "notices/index"
  get "notices/show"

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "staticpages#top"
  get "contact", to: "staticpages#contact", as: "contact"
  get "terms", to: "staticpages#terms", as: "terms"
  get "privacy", to: "staticpages#privacy", as: "privacy"

  resources :notices, only: [ :index, :show ]
  get "/notices", to: "notices#index", as: "static_notices"

  devise_scope :user do
    get "users/:id", to: "users/registrations#show", as: :user
    get "users/:id/edit", to: "users/registrations#edit", as: :edit_user
    patch "users/:id", to: "users/registrations#update", as: :update_user
  end

  resources :museums do
    resources :images, only: [ :destroy ]

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

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
