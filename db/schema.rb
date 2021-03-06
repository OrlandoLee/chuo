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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140831201742) do

  create_table "business_meta", force: true do |t|
    t.integer  "user_id",                      null: false
    t.string   "name",                         null: false
    t.integer  "redeem_number",                null: false
    t.string   "location"
    t.string   "phone"
    t.string   "logo"
    t.boolean  "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "one_time_code", default: true
  end

  create_table "businesses", force: true do |t|
    t.string   "qr_code"
    t.integer  "random"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.integer  "business_meta_id"
  end

  add_index "businesses", ["qr_code"], name: "index_businesses_on_qr_code", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.boolean  "exchange",    default: false
    t.integer  "amount",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "transactions", ["business_id"], name: "index_transactions_on_business_id", using: :btree
  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 1
    t.boolean  "admin",                  default: false
    t.integer  "business_meta_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
