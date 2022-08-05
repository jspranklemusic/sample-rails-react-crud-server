Rails.application.routes.draw do
  resources :authors
  resources :jobs
  resources :job_hazard_analyses
  post 'login', to: 'authors#login'
  get 'login', to: 'authors#login'
  get 'logout', to: 'authors#logout'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
