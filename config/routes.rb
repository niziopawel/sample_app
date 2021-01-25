Rails.application.routes.draw do
  # for root address call hello method from application controller
  root 'static_pages#home' 

  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/about', to: 'static_pages#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
