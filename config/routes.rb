Rails.application.routes.draw do
  root "api/data#index"

  namespace :api do 
    get :data, to: "data#index"
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' # setting UI to http://localhost:3000/sidekiq
end
