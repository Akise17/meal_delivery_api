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

ActiveRecord::Schema.define(version: 2021_10_28_190108) do

  create_table "business_hours", charset: "utf8mb4", force: :cascade do |t|
    t.integer "restaurant_id"
    t.string "day"
    t.string "open_time"
    t.string "close_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menus", charset: "utf8mb4", force: :cascade do |t|
    t.integer "restaurant_id"
    t.string "name"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restaurants", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.float "balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude", default: 0.0
    t.float "longitude", default: 0.0
    t.index ["latitude", "longitude"], name: "index_restaurants_on_latitude_and_longitude"
  end

  create_table "transactions", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.string "restaurant_name"
    t.string "dish"
    t.float "amount"
    t.datetime "purchase_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "encrypted_password"
    t.string "location"
    t.float "balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
