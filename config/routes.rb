Youplay::Application.routes.draw do

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout", sign_up: "register"}

  root to: redirect("/player")
  get "youtube/auth/(:state)" => "youtube#connect", as: "youtube_connect"
  get "youtube/reset" => "youtube#reset", as: "youtube_reset"
  namespace :player do
    get "" => "player#index"
    get "video" => "player#video", as: "video"
    get "video/download/:v/:itag" => "player#video_download", as: "video_download"
    get "broadcast" => "player#broadcast", as: "broadcast"
  end
  namespace :reader do
    get "" => "reader#index"
    delete "show(/:id)" => "reader#show", as: "show"
    delete ":id" => "reader#hide", as: "hide"
    get "update" => "reader#update"
    get "hidden" => "reader#hidden"
    get "subscribe" => "subscribe#index"
    delete "subscribe/channel(/:channel)" => "subscribe#channel_delete", as: "delete_channel"
    delete "subscribe/broadcast(/:broadcast)" => "subscribe#broadcast_delete", as: "delete_broadcast"
    post "subscribe/channel" => "subscribe#channel_add", as: "add_channel"
  end
  namespace :log do
    get "(:page/(:results))" => "log#index"
    delete ":id" => "log#destroy", as: "delete_video"
  end
  namespace :conf do
    get "" => "conf#settings"
    get "settings" => "conf#settings", as: "edit_settings"
    put "settings" => "conf#update_settings", as: "update_settings"
    resources :users, except: :show
    resources :people, except: :show
  end
  namespace :stats do
    get "" => "stats#index"
  end
  get "imprint" => "meta#imprint", as: "imprint"
  #match ":anything" => "application#bad_request"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
