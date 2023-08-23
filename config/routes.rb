Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root 'pages#home'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :api do
    namespace :v1 do
      resources :roles, only: [:create]
      scope :roles do
        get 'all', to: 'roles#index'
        get '/', to: 'roles#index'
        post '/', to: 'roles#create'
        get '/:id', to: 'roles#show'
        patch '/:id', to: 'roles#update'
        put '/:id', to: 'roles#update'
        delete '/:id', to: 'roles#destroy'
        get '/:id/users', to: 'roles#get_users'
        post '/:id/users/add', to: 'roles#add_user'
        delete '/:id/users/:userroleid', to: 'roles#destroy_user'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      scope :users do
        get '/', to: 'users#index'
        post '/', to: 'users#create'
        get '/:id', to: 'users#show'
        patch '/:id', to: 'users#update'
        put '/:id', to: 'users#update'
        delete '/:id', to: 'users#destroy'
      end
    end
  end
end
