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
    delete "" => "reader#hide", as: "hide"
    get "update" => "worker#update"
    get "tidy" => "worker#tidy"
    delete "show(/:id)" => "reader#show", as: "show"
    delete "channel/:channel" => "reader#hide_channel", as: "hide_channel"
    get "hidden" => "reader#hidden"
    get "hiding_rules" => "hiding_rules#index", as: "hiding_rules"
    delete "hiding_rules/:hiding_rule" => "hiding_rules#destroy", as: "delete_hiding_rule"
    post "hiding_rules" => "hiding_rules#create", as: "add_hiding_rule"
    get "subscribe" => "subscribe#index"
    delete "subscribe/channel(/:channel)" => "subscribe#destroy", as: "delete_channel"
    post "subscribe/channel" => "subscribe#create", as: "add_channel"
  end
  
  namespace :log do
    get "favorite/:id" => "log#set_favorite", as: "set_favorite"
    delete "favorite/:id" => "log#unset_favorite", as: "unset_favorite"
    get "(:page/:results)" => "log#index"
    post "(:page/:results)" => "log#category"
    delete ":id" => "log#destroy", as: "delete_video"
  end
  
  namespace :conf do
    get "" => "conf#settings"
    get "" => "conf#settings", as: "edit_settings"
    put "settings" => "conf#update_settings", as: "update_settings"
    resources :users, except: :show
    resources :people, except: :show
    resources :categories, except: :show
  end
  
  namespace :stats do
    get "" => "stats#index"
  end
  
  namespace :api do
    get "login" => "auth#login"
    get "" => "player#index"
    get "play" => "player#play"
    get "category/:category" => "player#category"
    get "share/:person" => "player#share"
    get "log(/:search(/:page/:results))" => "log#index"
    get "reader" => "reader#index"
    get "subscribe" => "reader#subscribe"
    get "add_hiding_rule" => "reader#add_hiding_rule"
  end
  
end
