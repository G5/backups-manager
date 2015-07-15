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

ActiveRecord::Schema.define(version: 20150630200831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: true do |t|
    t.json     "app_details"
    t.json     "dynos"
    t.json     "addons"
    t.json     "config_variables"
    t.json     "domains"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "g5_authenticatable_roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "g5_authenticatable_roles", ["name", "resource_type", "resource_id"], name: "index_g5_authenticatable_roles_on_name_and_resource", using: :btree
  add_index "g5_authenticatable_roles", ["name"], name: "index_g5_authenticatable_roles_on_name", using: :btree

  create_table "g5_authenticatable_users", force: true do |t|
    t.string   "email",              default: "",   null: false
    t.string   "provider",           default: "g5", null: false
    t.string   "uid",                               null: false
    t.string   "g5_access_token"
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "title"
    t.string   "organization_name"
  end

  add_index "g5_authenticatable_users", ["email"], name: "index_g5_authenticatable_users_on_email", unique: true, using: :btree
  add_index "g5_authenticatable_users", ["provider", "uid"], name: "index_g5_authenticatable_users_on_provider_and_uid", unique: true, using: :btree

  create_table "g5_authenticatable_users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "g5_authenticatable_users_roles", ["user_id", "role_id"], name: "index_g5_authenticatable_users_roles_on_user_id_and_role_id", using: :btree

end
