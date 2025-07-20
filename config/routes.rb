Rails.application.routes.draw do
  root to: "docs#readme"

  namespace :api do
    post "/complexity-score", to: "complexity#create"
    get "/complexity-score/:id", to: "complexity#show"
  end

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq" # setting UI to http://localhost:3000/sidekiq
end
