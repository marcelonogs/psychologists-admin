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

ActiveRecord::Schema.define(:version => 20140606205743) do

  create_table "bills", :force => true do |t|
    t.string   "reference_number"
    t.string   "payment_status"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "contact_id"
    t.string   "status",           :default => "draft"
    t.text     "comments"
    t.date     "sent_on"
    t.date     "paid_on"
    t.date     "recall_sent_on"
    t.text     "notes"
  end

  create_table "contacts", :force => true do |t|
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "birthdate"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone_pro"
    t.string   "phone_perso"
    t.string   "phone_mobile"
    t.string   "civil_status"
    t.boolean  "is_archived"
    t.string   "referent"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "country"
    t.string   "bureau"
    t.float    "rate_30",               :default => 110.0
    t.float    "rate_45",               :default => 165.0
    t.float    "rate_60",               :default => 220.0
    t.boolean  "is_cotherapy",          :default => false
    t.float    "rate_cotherapy"
    t.string   "phone_mobile_2"
    t.integer  "bill_every_x_sessions", :default => 6
    t.boolean  "is_bill_every_month"
    t.string   "billing_firstname"
    t.string   "billing_lastname"
    t.string   "billing_address"
    t.boolean  "is_billing_contact"
    t.string   "billing_title"
    t.string   "billing_street"
    t.string   "billing_zipcode"
    t.string   "billing_city"
    t.string   "billing_country"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nationalities", :force => true do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "series", :force => true do |t|
    t.date     "start_date"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "sessions", :force => true do |t|
    t.date     "start_date"
    t.integer  "bill_id"
    t.integer  "serie_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "observations"
    t.string   "duration"
    t.float    "price"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
