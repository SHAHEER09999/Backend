# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_16_091254) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_user_managements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_admin_user_managements_on_user_id"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "account_name"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_bank_accounts_on_profile_id"
  end

  create_table "campaign_applications", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "profile_id"], name: "index_campaign_applications_on_campaign_id_and_profile_id", unique: true
    t.index ["campaign_id"], name: "index_campaign_applications_on_campaign_id"
    t.index ["profile_id"], name: "index_campaign_applications_on_profile_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.decimal "budget", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "platform"
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_campaigns_on_profile_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "categories"
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_categories_on_profile_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.bigint "influencer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id", "influencer_id"], name: "index_conversations_on_brand_id_and_influencer_id", unique: true
    t.index ["brand_id"], name: "index_conversations_on_brand_id"
    t.index ["influencer_id"], name: "index_conversations_on_influencer_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "brand_profile_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.index ["brand_profile_id"], name: "index_feedbacks_on_brand_profile_id"
    t.index ["profile_id", "brand_profile_id"], name: "index_feedbacks_on_profile_id_and_brand_profile_id", unique: true
    t.index ["profile_id"], name: "index_feedbacks_on_profile_id"
  end

  create_table "meeting_responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "meeting_id", null: false
    t.bigint "profile_id", null: false
    t.text "reason"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_meeting_responses_on_meeting_id"
    t.index ["profile_id"], name: "index_meeting_responses_on_profile_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "date_time"
    t.string "location_link"
    t.integer "meeting_type"
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_meetings_on_campaign_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "delivery_time"
    t.text "description"
    t.integer "gender"
    t.string "language"
    t.string "location_website"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "reported_profile_id", null: false
    t.bigint "reporter_profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["reported_profile_id"], name: "index_reports_on_reported_profile_id"
    t.index ["reporter_profile_id"], name: "index_reports_on_reporter_profile_id"
  end

  create_table "social_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "followers", null: false
    t.integer "platform"
    t.decimal "price"
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["profile_id"], name: "index_social_accounts_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "delete_sent_at"
    t.string "delete_token"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_user_managements", "users"
  add_foreign_key "bank_accounts", "profiles"
  add_foreign_key "campaign_applications", "campaigns"
  add_foreign_key "campaign_applications", "profiles"
  add_foreign_key "campaigns", "profiles"
  add_foreign_key "categories", "profiles"
  add_foreign_key "conversations", "users", column: "brand_id"
  add_foreign_key "conversations", "users", column: "influencer_id"
  add_foreign_key "feedbacks", "profiles"
  add_foreign_key "feedbacks", "profiles", column: "brand_profile_id"
  add_foreign_key "meeting_responses", "meetings"
  add_foreign_key "meeting_responses", "profiles"
  add_foreign_key "meetings", "campaigns"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "reports", "profiles", column: "reported_profile_id"
  add_foreign_key "reports", "profiles", column: "reporter_profile_id"
  add_foreign_key "social_accounts", "profiles"
end
