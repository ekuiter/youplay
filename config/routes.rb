Youplay::Application.routes.draw do

  post "users" => "application#nothing"
  get "users/sign_up" => "application#nothing"
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  root to: "player/player#index"
  get "channel" => "channel#info", as: "channel_info"
  get "play" => "player/player#play", as: "play"

  namespace :player do
    get "" => "player#index"
  end
  
  namespace :reader do
    get "" => "reader#index"
    get "json" => "reader#json"
    delete "" => "reader#hide", as: "hide"
    get "update" => "reader#update"
    delete "show(/:id)" => "reader#show", as: "show"
    delete "channel/:channel" => "reader#hide_channel", as: "hide_channel"
    get "hidden" => "reader#hidden"
    get "subscribe" => "subscribe#index"
    delete "subscribe/channel(/:channel)" => "subscribe#channel_delete", as: "delete_channel"
    post "subscribe/channel" => "subscribe#channel_add", as: "add_channel"
  end
  
  namespace :log do
    get "json" => "log#log_json"
    get "favorites/json" => "log#favorites_json"
    get "favorites(/:page/(:results))" => "log#favorites", as: "favorites"
    get "favorite/:id" => "log#set_favorite", as: "set_favorite"
    delete "favorite/:id" => "log#unset_favorite", as: "unset_favorite"
    get "(:page/(:results))" => "log#index"
    delete ":id" => "log#destroy", as: "delete_video"
  end
  
  namespace :conf do
    get "" => "conf#settings"
    get "" => "conf#settings", as: "edit_settings"
    put "settings" => "conf#update_settings", as: "update_settings"
    resources :users, except: :show
    resources :people, except: :show
  end
  
  namespace :stats do
    get "" => "stats#index"
  end
  
end
