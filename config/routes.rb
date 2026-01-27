Rails.application.routes.draw do
  # API Version 1
  namespace :api do
    namespace :v1 do
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
    end
  end
end