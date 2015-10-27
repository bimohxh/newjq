Rails.application.routes.draw do  
  post 'resque/publish'
  get 'resque/subscribers'
  
  #namespace :subscribers do
  #  mount Alert::API => '/'
  #end
  require 'resque/server'
  mount Resque::Server.new, at: "/resque"
  
  # 遗留路由 
  match "/jquery-info:id", :controller =>  "plugin",:action=> "index",id: /\d+/,via: ['get']
  match "/jquery/1:rtyp", :controller =>  "home",:action=> "plugins",id: /\d+/,via: ['get']
  match "/jquery/:typ", :controller =>  "home",:action=> "plugins",id: /\d+/,via: ['get']

  
  get "/auth/:provider/callback" => "home#auth"

  match "/:controller(/:id)(/:action)(/:search)(.:format)", :controller =>  /admin\/[^\/]+/,id: /\d+/,via: ['get','post']
  match "/admin/:action(/:page)(/:search)(.:format)", :controller =>  "admin/home",id: /\d+/,via: ['get','post']
  
  match "/:controller(/:id)(/:action)(/:search)(.:format)", :controller =>  /mem\/[^\/]+/,id: /\d+/,via: ['get','post']
  
  match "/:controller(/:id)(/:action)(/:search)(.:format)" ,id: /\d+/,via: ['get','post']
  match "/:action(/:page)(/:search)(.:format)" ,controller: 'home',page: /\d+/,via: ['get','post']

  
  #['mem', 'group', 'article', 'album'].each do |r|
  #  get "/#{r}(/:id)(/:action)(/:search)" ,:controller=>"sns_#{r}",id: /\d+/
  #end 

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#plugins'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
