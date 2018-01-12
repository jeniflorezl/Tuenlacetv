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

ActiveRecord::Schema.define(version: 20180111233008) do

  create_table "bancos", force: :cascade do |t|
    t.varchar "nit", limit: 13
    t.varchar "nombre", limit: 40, null: false
    t.varchar "direccion", limit: 50
    t.bigint "ciudad_id"
    t.varchar "telefono1", limit: 15
    t.varchar "telefono2", limit: 15
    t.varchar "contacto", limit: 50
    t.varchar "cuentaBancaria", limit: 15
    t.varchar "cuentaContable", limit: 15
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["ciudad_id"], name: "index_bancos_on_ciudad_id"
  end

  create_table "barrios", force: :cascade do |t|
    t.bigint "zona_id"
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["zona_id"], name: "index_barrios_on_zona_id"
  end

  create_table "ciudades", force: :cascade do |t|
    t.bigint "pais_id"
    t.varchar "nombre", limit: 80, null: false
    t.char "codigo", limit: 5
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["pais_id"], name: "index_ciudades_on_pais_id"
  end

  create_table "conceptos", force: :cascade do |t|
    t.bigint "servicio_id"
    t.char "codigo", limit: 3, null: false
    t.varchar "nombre", limit: 20, null: false
    t.float "porcentajeIva", null: false
    t.varchar "tipoDocumento", limit: 20, null: false
    t.varchar "abreviatura", limit: 20, null: false
    t.char "operacion", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["servicio_id"], name: "index_conceptos_on_servicio_id"
  end

  create_table "direcciones_zonas", force: :cascade do |t|
    t.bigint "zona_id"
    t.varchar "direccion", limit: 100, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["zona_id"], name: "index_direcciones_zonas_on_zona_id"
  end

  create_table "nomenclaturas", force: :cascade do |t|
    t.varchar "abreviatura", limit: 10, null: false
    t.varchar "descripcion", limit: 50
    t.integer "orden"
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "paises", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "servicios", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "tecnologias", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "tipo_instalaciones", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
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

  add_foreign_key "bancos", "ciudades"
  add_foreign_key "barrios", "zonas"
  add_foreign_key "ciudades", "paises"
  add_foreign_key "conceptos", "servicios"
  add_foreign_key "direcciones_zonas", "zonas"
  add_foreign_key "zonas", "ciudades"
end
