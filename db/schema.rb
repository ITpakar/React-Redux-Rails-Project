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

ActiveRecord::Schema.define(version: 20160621000001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.boolean  "activated"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "deal_id"
  end

  create_table "closing_book_documents", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "closing_book_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "closing_books", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "status"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "index_type"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "organization_user_id"
    t.string   "comment_type"
    t.text     "comment"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "deal_id"
    t.index ["organization_user_id"], name: "index_comments_on_organization_user_id", using: :btree
  end

  create_table "deal_collaborator_invites", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "email"
    t.integer  "added_by"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by"], name: "index_deal_collaborator_invites_on_added_by", using: :btree
    t.index ["deal_id", "email"], name: "index_deal_collaborator_invites_on_deal_id_and_email", unique: true, using: :btree
    t.index ["deal_id"], name: "index_deal_collaborator_invites_on_deal_id", using: :btree
    t.index ["token"], name: "index_deal_collaborator_invites_on_token", unique: true, using: :btree
  end

  create_table "deal_collaborators", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "organization_user_id"
    t.integer  "added_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "type"
    t.index ["added_by"], name: "index_deal_collaborators_on_added_by", using: :btree
    t.index ["deal_id"], name: "index_deal_collaborators_on_deal_id", using: :btree
    t.index ["organization_user_id"], name: "index_deal_collaborators_on_organization_user_id", using: :btree
  end

  create_table "deal_document_versions", force: :cascade do |t|
    t.integer  "deal_document_id"
    t.string   "name"
    t.string   "box_file_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "url"
    t.string   "download_url"
    t.index ["deal_document_id"], name: "index_deal_document_versions_on_deal_document_id", using: :btree
  end

  create_table "deal_documents", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "deal_id"
    t.index ["document_id"], name: "index_deal_documents_on_document_id", using: :btree
    t.index ["documentable_id"], name: "index_deal_documents_on_documentable_id", using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.string   "title",                limit: 250
    t.string   "client_name"
    t.string   "transaction_type"
    t.date     "projected_close_date"
    t.string   "status"
    t.boolean  "activated"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "deal_size"
    t.integer  "organization_user_id"
    t.integer  "organization_id"
    t.index ["activated"], name: "index_deals_on_activated", using: :btree
    t.index ["status"], name: "index_deals_on_status", using: :btree
    t.index ["title"], name: "index_deals_on_title", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "document_signers", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "document_id"
    t.boolean  "signed",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "envelope_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.datetime "file_uploaded_at"
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "deal_id"
    t.integer  "visibility",       default: 0
    t.index ["created_by"], name: "index_documents_on_created_by", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "deal_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "action"
    t.integer  "eventable_id"
    t.string   "eventable_type"
  end

  create_table "folders", force: :cascade do |t|
    t.string   "name",       limit: 250
    t.integer  "created_by"
    t.boolean  "activated"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "deal_id"
    t.integer  "task_id"
    t.integer  "visibility",             default: 0
    t.index ["created_by"], name: "index_folders_on_created_by", using: :btree
  end

  create_table "kpis", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "key"
    t.integer  "value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "organization_user_id"
    t.text     "message"
    t.string   "status"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "organization_users", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "invitation_accepted"
    t.string   "invitation_token"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "type"
    t.string   "box_user_id"
    t.string   "record_type",         limit: 255
    t.index ["invitation_accepted"], name: "index_organization_users_on_invitation_accepted", using: :btree
    t.index ["organization_id"], name: "index_organization_users_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_organization_users_on_user_id", using: :btree
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "visibility",              default: 0
    t.index ["activated"], name: "index_sections_on_activated", using: :btree
    t.index ["created_by"], name: "index_sections_on_created_by", using: :btree
  end

  create_table "starred_deals", force: :cascade do |t|
    t.integer  "organization_user_id"
    t.integer  "deal_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title",                limit: 250
    t.string   "description",          limit: 1000
    t.string   "status",               limit: 30
    t.integer  "section_id"
    t.integer  "assignee_id"
    t.integer  "organization_user_id"
    t.integer  "deal_id"
    t.datetime "due_date"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "visibility",                        default: 0
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id", using: :btree
    t.index ["section_id"], name: "index_tasks_on_section_id", using: :btree
    t.index ["status"], name: "index_tasks_on_status", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",                  limit: 15
    t.string   "address"
    t.string   "company",                limit: 100
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
    t.string   "avatar"
    t.index ["activated"], name: "index_users_on_activated", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role"], name: "index_users_on_role", using: :btree
  end

end
