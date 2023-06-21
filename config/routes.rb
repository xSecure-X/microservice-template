Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'



root 'pages#home'
devise_for :users,controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions',
  omniauth_callbacks: 'users/omniauth_callbacks'
}


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
