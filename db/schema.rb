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

ActiveRecord::Schema.define(version: 20180110030837) do

  create_table "ciudades", force: :cascade do |t|
    t.bigint "pais_id"
    t.varchar "nombre", limit: 80, null: false
    t.char "codigo", limit: 5
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["pais_id"], name: "index_ciudades_on_pais_id"
  end

  create_table "paises", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "zonas", force: :cascade do |t|
    t.bigint "ciudad_id"
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["ciudad_id"], name: "index_zonas_on_ciudad_id"
  end

  add_foreign_key "ciudades", "paises"
  add_foreign_key "zonas", "ciudades"
end
