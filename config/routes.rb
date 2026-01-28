Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # Auth
      post 'login', to: 'auth#login'

      # Admin endpoints
      namespace :admin do
        get 'stats', to: 'stats#index'
        get 'audit_logs', to: 'audit_logs#index'
      end

      # Creators endpoints
      resources :creators, only: [:index, :show, :update] do
        get 'media', on: :member
      end

      # Media endpoints
      resources :media, only: [:index, :create, :destroy]

      # Thumbnail proxy
      get 'resize', to: 'resize#show'
      post 'import/media', to: 'import#media'
    end
  end
end
