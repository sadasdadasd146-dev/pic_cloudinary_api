Rails.application.routes.draw do
  resources :media
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post "media/bulk_create", to: "media#bulk_create"
    post "media/bulk_create2", to: "media#bulk_create2"


    get "users/:username/media", to: "media#by_user"
    get "users/top", to: "users#top"



    delete "users/:username/media/bulk_delete", to: "media#bulk_delete"




  end




end
