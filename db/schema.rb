# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141228203225) do

  create_table "cached_videos", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "channel"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "uploaded_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "channels", :force => true do |t|
    t.string   "channel_id"
    t.string   "channel_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "provider"
  end

  create_table "configurations", :force => true do |t|
    t.string   "feature"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hide_videos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cached_video_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "channel"
  end

  create_table "hiding_rules", :force => true do |t|
    t.integer  "user_id"
    t.string   "pattern"
    t.string   "channel"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscribed_channels", :force => true do |t|
    t.string   "channel"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.string   "role",                   :default => "user", :null => false
    t.string   "username",               :default => "",     :null => false
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "authentication_token"
    t.date     "birthday"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "channel_topic"
    t.string   "browser"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "duration"
    t.string   "provider"
    t.integer  "category_id"
    t.integer  "comment_length"
  end

end
