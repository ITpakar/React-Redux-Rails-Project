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

ActiveRecord::Schema.define(version: 20160526045139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.boolean  "activated"
    t.integer  "parent_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.integer  "document_id"
    t.string   "comment_type"
    t.text     "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "deal_collaborators", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.integer  "added_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by"], name: "index_deal_collaborators_on_added_by", using: :btree
    t.index ["deal_id"], name: "index_deal_collaborators_on_deal_id", using: :btree
    t.index ["user_id"], name: "index_deal_collaborators_on_user_id", using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "title",                limit: 250
    t.string   "client_name"
    t.string   "transaction_type"
    t.string   "deal_size"
    t.date     "projected_close_date"
    t.float    "completion_percent"
    t.string   "status"
    t.integer  "admin_user_id"
    t.boolean  "activated"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["activated"], name: "index_deals_on_activated", using: :btree
    t.index ["admin_user_id"], name: "index_deals_on_admin_user_id", using: :btree
    t.index ["status"], name: "index_deals_on_status", using: :btree
    t.index ["title"], name: "index_deals_on_title", using: :btree
  end

  create_table "document_signers", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.boolean  "signed",      default: false
    t.datetime "signed_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.datetime "file_uploaded_at"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "deal_id"
    t.index ["created_by"], name: "index_documents_on_created_by", using: :btree
    t.index ["parent_id"], name: "index_documents_on_parent_id", using: :btree
    t.index ["parent_type"], name: "index_documents_on_parent_type", using: :btree
  end

  create_table "folders", force: :cascade do |t|
    t.string   "name",        limit: 250
    t.string   "parent_type"
    t.integer  "parent_id"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "deal_id"
    t.index ["created_by"], name: "index_folders_on_created_by", using: :btree
    t.index ["parent_id"], name: "index_folders_on_parent_id", using: :btree
    t.index ["parent_type"], name: "index_folders_on_parent_type", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "message"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organization_users", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "user_type",           limit: 30
    t.boolean  "invitation_accepted"
    t.string   "invitation_token"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["invitation_accepted"], name: "index_organization_users_on_invitation_accepted", using: :btree
    t.index ["organization_id"], name: "index_organization_users_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_organization_users_on_user_id", using: :btree
    t.index ["user_type"], name: "index_organization_users_on_user_type", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",         limit: 250
    t.string   "email_domain"
    t.string   "phone"
    t.string   "address"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["activated"], name: "index_organizations_on_activated", using: :btree
    t.index ["created_by"], name: "index_organizations_on_created_by", using: :btree
    t.index ["name"], name: "index_organizations_on_name", unique: true, using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name",        limit: 100
    t.integer  "deal_id"
    t.integer  "category_id"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["activated"], name: "index_sections_on_activated", using: :btree
    t.index ["created_by"], name: "index_sections_on_created_by", using: :btree
  end

  create_table "starred_deals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",           limit: 250
    t.string   "description",     limit: 1000
    t.string   "status",          limit: 30
    t.integer  "section_id"
    t.integer  "assignee_id"
    t.integer  "organization_id"
    t.integer  "deal_id"
    t.integer  "created_by"
    t.datetime "due_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id", using: :btree
    t.index ["created_by"], name: "index_tasks_on_created_by", using: :btree
    t.index ["section_id"], name: "index_tasks_on_section_id", using: :btree
    t.index ["status"], name: "index_tasks_on_status", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",                  limit: 15
    t.string   "address"
    t.string   "company",                limit: 100
    t.string   "avatar_name"
    t.integer  "avatar_size"
    t.string   "avatar_type"
    t.datetime "avatar_uploaded_at"
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
    t.boolean  "activated"
    t.string   "role"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["activated"], name: "index_users_on_activated", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role"], name: "index_users_on_role", using: :btree
  end

end
