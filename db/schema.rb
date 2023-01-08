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

ActiveRecord::Schema[7.0].define(version: 2023_01_08_191928) do
  create_sequence "transaction_id_seq"

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "pan", null: false
    t.string "holder", null: false
    t.integer "exp_month", null: false
    t.integer "exp_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "pan"], name: "index_credit_cards_on_account_id_and_pan", unique: true
    t.index ["account_id"], name: "index_credit_cards_on_account_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "transaction_id", default: -> { "nextval('transaction_id_seq'::regclass)" }, null: false
    t.bigint "account_id", null: false
    t.bigint "credit_card_id", null: false
    t.integer "amount", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["credit_card_id"], name: "index_payments_on_credit_card_id"
  end

  add_foreign_key "credit_cards", "accounts"
  add_foreign_key "payments", "accounts"
  add_foreign_key "payments", "credit_cards"
end
