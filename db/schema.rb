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

ActiveRecord::Schema.define(:version => 20111017081303) do

  create_table "tweets", :force => true do |t|
    t.integer  "user_id"
    t.string   "long_url"
    t.string   "short_url"
    t.string   "message"
    t.integer  "user_clicks",                 :default => 0
    t.integer  "global_clicks",               :default => 0
    t.string   "status",                      :default => "pending"
    t.datetime "scheduled_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tweet_uid",      :limit => 8
    t.string   "error"
    t.datetime "sent_date"
  end

  create_table "users", :force => true do |t|
    t.integer  "twitter_uid"
    t.string   "twitter_handle"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_address"
    t.string   "bitly_username"
    t.string   "bitly_api_key"
    t.string   "access_token"
    t.string   "time_zone"
    t.integer  "quick_pick_start",    :default => 7
    t.integer  "quick_pick_interval", :default => 5
  end

end
