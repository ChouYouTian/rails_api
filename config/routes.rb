Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/",to: redirect("spa.html")

  get "user"=>"users#index"
  get "user/logout"=>"users#logout"
  get "user/delete"=>"users#delete"
  post "user/login"=>"users#login"
  post "user/signup"=>"users#signup"



  get "product/providers"=>"product#getProviders"
  get "product/products"=>"product#getProducts"
  post "product/addProducts"=>"product#addProducts"
  post "product/updateProducts"=>"product#updateProducts"
  post "product/deleteProducts"=>"product#deleteProducts"

  get "cart"=>"cart#myCart"
  post "cart/addToCart"=>"cart#addToCart"
  post "cart/updateCarts"=>"cart#updateCarts"
  post "cart/deleteCarts"=>"cart#deleteCarts"

  get "trade"=>"trade#myTrade"
  post "trade/create"=>"trade#create"
  post "trade/create"=>"trade#update"

  get "cart/test"=>"cart#testCart"
  


end
