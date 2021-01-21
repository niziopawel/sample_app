Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # for root address call hello method from application controller
  root 'application#hello' 
end
