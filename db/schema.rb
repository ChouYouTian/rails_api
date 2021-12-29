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

ActiveRecord::Schema.define(version: 2021_12_29_142032) do

  create_table "carts", force: :cascade do |t|
    t.integer "amount", default: 1, null: false
    t.integer "total_price", null: false
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "trade_id"
    t.string "state", default: "active", null: false
    t.string "msg"
    t.integer "product_user_id", default: -1, null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 10, null: false
    t.string "user_type", default: "user", null: false
    t.integer "amount", default: 0, null: false
    t.string "discount_type", default: "price", null: false
    t.integer "discount_amount", default: 0, null: false
    t.integer "discount_ordinal", default: 0, null: false
    t.date "start", null: false
    t.date "end", null: false
    t.string "state", default: "disable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_coupons_on_name"
    t.index ["user_id"], name: "index_coupons_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", default: 0, null: false
    t.integer "quentity", default: 0, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products_tags_rels", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_products_tags_rels_on_product_id"
    t.index ["tag_id"], name: "index_products_tags_rels_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "trades", force: :cascade do |t|
    t.string "state", default: "start", null: false
    t.text "detail", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "total_price", null: false
    t.string "trade_no"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  create_table "users_coupons_rels", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "coupon_id"
    t.integer "amount", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_id"], name: "index_users_coupons_rels_on_coupon_id"
    t.index ["user_id"], name: "index_users_coupons_rels_on_user_id"
  end

end
