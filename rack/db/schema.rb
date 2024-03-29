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

ActiveRecord::Schema[7.0].define(version: 2023_08_08_162152) do
  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "piece_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["piece_id"], name: "index_comments_on_piece_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "brand"
    t.string "model"
    t.date "purchase_date"
    t.decimal "purchase_price", precision: 8, scale: 2
    t.string "purchase_location"
    t.string "serial_number"
    t.date "retired_on"
  end

  add_foreign_key "comments", "pieces"
end
