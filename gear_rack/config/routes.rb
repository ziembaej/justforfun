Rails.application.routes.draw do
  root "articles#index"

  ## old simple routes
  # get "/articles", to: "articles#index"
  # get "/articles/:id", to: "articles#show"
  
  ## Upgraded to using resources
  resources :articles do 
    resources :comments
  end
end
