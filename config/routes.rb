# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # Auth
      post 'login', to: 'auth#login'

      # Admin
      namespace :admin do
        get 'stats', to: 'stats#index'
        get 'audit_logs', to: 'audit_logs#index'
      end

      # Creators
      resources :creators, only: [:index, :show, :create, :update] do
        get 'assets', on: :member
      end

      # Assets (แทน media เดิม)
      resources :assets, only: [:index, :create, :destroy]

      # Thumbnail / Resize proxy
      get 'resize', to: 'resize#show'

      # Import
      post 'import/assets', to: 'import#assets'
      post 'import/media', to: 'import#media'
    end
  end
end
