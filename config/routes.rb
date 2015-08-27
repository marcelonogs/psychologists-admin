IFP::Application.routes.draw do

  get '/home', to: "pages#home", as: :public_home
  get '/qualifications', to: "pages#qualifications", as: :public_qualifications
  get '/contact', to: "pages#contact", as: :public_contact
  get "pages/refnum"

  get '/search', to: "pages#search_reference", as: :search_reference

  devise_for :users

  resources :contacts do
    resources :bills
  end

  resources :series do
    resources :sessions
  end

  root to: 'contacts#index'

  match ':controller(/:action(/:id))(.:format)'
end
