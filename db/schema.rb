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

ActiveRecord::Schema.define(version: 20180216011028) do

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
    t.char "codigoDane", limit: 5
    t.char "codigoAlterno", limit: 5
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

  create_table "empresas", force: :cascade do |t|
    t.char "tipo", limit: 2, null: false
    t.char "nit", limit: 13, null: false
    t.varchar "razonsocial", limit: 80, null: false
    t.varchar "direccion", limit: 200, null: false
    t.varchar "telefono1", limit: 20, null: false
    t.varchar "telefono2", limit: 20
    t.bigint "ciudad_id"
    t.bigint "entidad_id"
    t.varchar "logoempresa", limit: 100
    t.varchar "correo", limit: 50
    t.char "regimen", limit: 1
    t.char "contribuyente", limit: 1
    t.char "centrocosto", limit: 4
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["ciudad_id"], name: "index_empresas_on_ciudad_id"
    t.index ["entidad_id"], name: "index_empresas_on_entidad_id"
  end

  create_table "entidades", force: :cascade do |t|
    t.bigint "funcion_id"
    t.bigint "persona_id"
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["funcion_id"], name: "index_entidades_on_funcion_id"
    t.index ["persona_id"], name: "index_entidades_on_persona_id"
  end

  create_table "estados", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.char "abreviatura", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "funciones", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
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

  create_table "personas", force: :cascade do |t|
    t.bigint "tipo_documento_id"
    t.varchar "documento", limit: 15, null: false
    t.varchar "nombre1", limit: 50, null: false
    t.varchar "nombre2", limit: 50
    t.varchar "apellido1", limit: 50, null: false
    t.varchar "apellido2", limit: 50
    t.varchar "direccion", limit: 200, null: false
    t.varchar "telefono1", limit: 20
    t.varchar "telefono2", limit: 20
    t.bigint "barrio_id"
    t.bigint "zona_id"
    t.varchar "correo", limit: 50
    t.datetime "fechanac"
    t.char "tipopersona", limit: 1, null: false
    t.integer "estrato"
    t.char "condicionfisica", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["barrio_id"], name: "index_personas_on_barrio_id"
    t.index ["tipo_documento_id"], name: "index_personas_on_tipo_documento_id"
    t.index ["zona_id"], name: "index_personas_on_zona_id"
  end

  create_table "planes", force: :cascade do |t|
    t.bigint "servicio_id"
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["servicio_id"], name: "index_planes_on_servicio_id"
  end

  create_table "senales", force: :cascade do |t|
    t.bigint "entidad_id"
    t.bigint "servicio_id"
    t.varchar "contrato", limit: 20, null: false
    t.varchar "direccion", limit: 200, null: false
    t.varchar "urbanizacion", limit: 200
    t.varchar "torre", limit: 20
    t.varchar "apto", limit: 20
    t.varchar "telefono1", limit: 20
    t.varchar "telefono2", limit: 20
    t.varchar "contacto", limit: 20
    t.integer "estrato"
    t.varchar "vivienda", limit: 15
    t.varchar "observacion", limit: 200
    t.bigint "barrio_id"
    t.bigint "zona_id"
    t.bigint "estado_id"
    t.datetime "fechacontrato", null: false
    t.integer "permanencia"
    t.integer "televisores"
    t.varchar "precinto", limit: 10
    t.bigint "vendedor_id"
    t.bigint "tipo_instalacion_id"
    t.bigint "tecnologia_id"
    t.varchar "tiposervicio", limit: 20
    t.varchar "areainstalacion", limit: 20
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["barrio_id"], name: "index_senales_on_barrio_id"
    t.index ["entidad_id"], name: "index_senales_on_entidad_id"
    t.index ["estado_id"], name: "index_senales_on_estado_id"
    t.index ["servicio_id"], name: "index_senales_on_servicio_id"
    t.index ["tecnologia_id"], name: "index_senales_on_tecnologia_id"
    t.index ["tipo_instalacion_id"], name: "index_senales_on_tipo_instalacion_id"
    t.index ["vendedor_id"], name: "index_senales_on_vendedor_id"
    t.index ["zona_id"], name: "index_senales_on_zona_id"
  end

  create_table "servicios", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "tarifas", force: :cascade do |t|
    t.bigint "zona_id"
    t.bigint "concepto_id"
    t.bigint "plan_id"
    t.money "valor", precision: 19, scale: 4, null: false
    t.bigint "estado_id"
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
    t.index ["concepto_id"], name: "index_tarifas_on_concepto_id"
    t.index ["estado_id"], name: "index_tarifas_on_estado_id"
    t.index ["plan_id"], name: "index_tarifas_on_plan_id"
    t.index ["zona_id"], name: "index_tarifas_on_zona_id"
  end

  create_table "tecnologias", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "tipo_documentos", force: :cascade do |t|
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

  create_table "usuarios", force: :cascade do |t|
    t.varchar "login", limit: 10, null: false
    t.varchar "nombre", limit: 50, null: false
    t.string "password_digest"
    t.char "nivel", limit: 1
    t.string "token"
    t.datetime "fechacre", default: -> { "getdate()" }
    t.datetime "fechacam", default: -> { "getdate()" }
    t.varchar "user", limit: 15, null: false
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
  add_foreign_key "empresas", "ciudades"
  add_foreign_key "empresas", "entidades"
  add_foreign_key "entidades", "funciones"
  add_foreign_key "entidades", "personas"
  add_foreign_key "personas", "barrios"
  add_foreign_key "personas", "tipo_documentos"
  add_foreign_key "personas", "zonas"
  add_foreign_key "planes", "servicios"
  add_foreign_key "senales", "barrios"
  add_foreign_key "senales", "entidades"
  add_foreign_key "senales", "entidades", column: "vendedor_id"
  add_foreign_key "senales", "estados"
  add_foreign_key "senales", "servicios"
  add_foreign_key "senales", "tecnologias"
  add_foreign_key "senales", "tipo_instalaciones"
  add_foreign_key "senales", "zonas"
  add_foreign_key "tarifas", "conceptos"
  add_foreign_key "tarifas", "estados"
  add_foreign_key "tarifas", "planes"
  add_foreign_key "tarifas", "zonas"
  add_foreign_key "zonas", "ciudades"
end
