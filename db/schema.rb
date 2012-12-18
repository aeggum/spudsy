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

ActiveRecord::Schema.define(:version => 20121216092536) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "actors", :force => true do |t|
    t.string   "name"
    t.integer  "media_id"
    t.string   "media_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "genres", ["name"], :name => "index_genres_on_name", :unique => true

  create_table "hidden_user_media", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_id"
    t.string   "media_type"
    t.boolean  "liked"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hidden_user_media", ["user_id"], :name => "index_hidden_user_media_on_user_id"

  create_table "media_genres", :force => true do |t|
    t.string   "media_type"
    t.integer  "media_id"
    t.integer  "genre_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "media_genres", ["media_id"], :name => "index_media_genres_on_media_id"
  add_index "media_genres", ["media_type"], :name => "index_media_genres_on_media_type"

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.float    "rating"
    t.text     "description"
    t.date     "release_date"
    t.float    "user_rating"
    t.string   "mpaa_rating"
    t.string   "poster"
    t.integer  "runtime"
    t.string   "rt_id"
    t.float    "popularity"
    t.boolean  "certified"
    t.float    "spudsy_rating"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "movies", ["name"], :name => "index_movies_on_name"

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tv_shows", :force => true do |t|
    t.string   "name"
    t.string   "tvdb_id"
    t.float    "rating"
    t.text     "description"
    t.string   "poster"
    t.date     "release_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.float    "spudsy_rating"
    t.string   "imdb_id"
    t.string   "runtime"
    t.string   "mpaa"
  end

  add_index "tv_shows", ["name"], :name => "index_tv_shows_on_name"
  add_index "tv_shows", ["spudsy_rating"], :name => "index_tv_shows_on_spudsy_rating"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "admin"
    t.integer  "zip"
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
