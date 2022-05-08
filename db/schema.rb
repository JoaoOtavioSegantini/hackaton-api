# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_01_121856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "complement"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zipcode"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.boolean "admin", default: false
    t.bigint "recepient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "accepted", default: 0
    t.index ["room_id"], name: "index_books_on_room_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "consults", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finish_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_rent_id"
    t.index ["room_rent_id"], name: "index_consults_on_room_rent_id"
    t.index ["user_id"], name: "index_consults_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.string "method"
    t.date "date"
    t.bigint "consult_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_id"], name: "index_payments_on_consult_id"
  end

  create_table "room_features", force: :cascade do |t|
    t.boolean "internet"
    t.boolean "airConditioned"
    t.boolean "bathroom"
    t.boolean "furnished"
    t.boolean "roomCleaning"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_id"
    t.index ["room_id"], name: "index_room_features_on_room_id"
  end

  create_table "room_rents", force: :cascade do |t|
    t.date "started_at"
    t.date "finish_at"
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.string "title"
    t.text "especialization"
    t.index ["room_id"], name: "index_room_rents_on_room_id"
    t.index ["user_id"], name: "index_room_rents_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "avaliable", default: true
    t.boolean "internet", default: false
    t.boolean "airConditioned", default: false
    t.boolean "bathroom", default: false
    t.boolean "furnished", default: false
    t.boolean "roomCleaning", default: false
    t.text "description"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email"
    t.integer "profile", default: 1
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "phone"
    t.boolean "whatsapp_avaliable", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "books", "rooms"
  add_foreign_key "books", "users"
  add_foreign_key "consults", "room_rents"
  add_foreign_key "consults", "users"
  add_foreign_key "payments", "consults"
  add_foreign_key "room_features", "rooms"
  add_foreign_key "room_rents", "rooms"
  add_foreign_key "room_rents", "users"
end
