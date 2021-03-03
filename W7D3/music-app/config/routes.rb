Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :bands do 
    resources :albums, only: [:new]
  end
  
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :albums, except: [:new]

  root "bands#index"
end
