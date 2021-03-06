Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :cats do
    member do
      resources :cat_rental_requests, only: [:index]
    end
  end

  resources :cat_rental_requests, except: [:index]
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
end
