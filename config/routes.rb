Rails.application.routes.draw do
  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Redirect root to uploaded files if authenticated, otherwise to login
  authenticated :user do
    root 'uploaded_files#index', as: :authenticated_root
  end
  
  # For unauthenticated users, redirect to login
  root 'uploaded_files#index'

  resources :uploaded_files do
    member do
      get :download
      patch :toggle_public
    end
  end

  # Public file sharing routes
  get '/f/:token', to: 'public_files#show', as: 'public_file'
  get '/f/:token/download', to: 'public_files#download', as: 'public_file_download'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end