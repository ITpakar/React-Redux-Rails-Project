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

ActiveRecord::Schema.define(version: 20160425121215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.boolean  "activated"
    t.integer  "parent_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "deal_collaborators", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.integer  "added_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deal_collaborators", ["added_by"], name: "index_deal_collaborators_on_added_by", using: :btree
  add_index "deal_collaborators", ["deal_id"], name: "index_deal_collaborators_on_deal_id", using: :btree
  add_index "deal_collaborators", ["user_id"], name: "index_deal_collaborators_on_user_id", using: :btree

  create_table "deals", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "title",                  limit: 250
    t.string   "client_name"
    t.string   "transaction_type"
    t.string   "deal_size"
    t.date     "projected_closing_date"
    t.float    "completion_percent"
    t.string   "status"
    t.integer  "admin_user_id"
    t.boolean  "activated"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "deals", ["activated"], name: "index_deals_on_activated", using: :btree
  add_index "deals", ["admin_user_id"], name: "index_deals_on_admin_user_id", using: :btree
  add_index "deals", ["status"], name: "index_deals_on_status", using: :btree
  add_index "deals", ["title"], name: "index_deals_on_title", using: :btree

  create_table "organization_users", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "is_admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_users", ["is_admin"], name: "index_organization_users_on_is_admin", using: :btree
  add_index "organization_users", ["organization_id"], name: "index_organization_users_on_organization_id", using: :btree
  add_index "organization_users", ["user_id"], name: "index_organization_users_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 250
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "organizations", ["activated"], name: "index_organizations_on_activated", using: :btree
  add_index "organizations", ["created_by"], name: "index_organizations_on_created_by", using: :btree
  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",                  limit: 15
    t.string   "address"
    t.string   "company",                limit: 100
    t.string   "avtar_name"
    t.integer  "avtar_size"
    t.string   "avtar_type"
    t.datetime "avtar_uploaded_at"
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
