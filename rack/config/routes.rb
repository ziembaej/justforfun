Rails.application.routes.draw do
  root "pieces#index"

  ## old simple routes
  # get "/pieces", to: "pieces#index"
  # get "/pieces/:id", to: "pieces#show"
  
  ## Upgraded to using resources
  resources :pieces do 
    resources :comments
  end
end
