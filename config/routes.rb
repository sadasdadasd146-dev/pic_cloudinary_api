# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # Auth
      post 'login', to: 'auth#login'
      get  'me',    to: 'auth#me'   # ⭐ user ที่ login อยู่

      # Admin
      namespace :admin do
        get 'stats', to: 'stats#index'
        get 'audit_logs', to: 'audit_logs#index'
      end

      # Users ⭐⭐⭐
      resources :users, only: [:index, :show, :destroy] do
        member do
          get :assets      # /api/v1/users/:id/assets
          get :media       # /api/v1/users/:id/media  🔥 แยกภาพ / วิดีโอ
        end

        collection do
          get :with_assets # /api/v1/users/with_assets 🔥 เรียงตาม asset มากสุด
        end
      end


      # Creators
      resources :creators, only: [:index, :show, :create, :update] do
        get 'assets', on: :member


      end

      # Assets
      resources :assets, only: [:index, :create, :destroy]

      # Resize
      get 'resize', to: 'resize#show'

      # Import
      post 'import/assets', to: 'import#assets'
      post 'import/media', to: 'import#media'
    end
  end
end
