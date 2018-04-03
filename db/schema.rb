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

ActiveRecord::Schema.define(version: 20180314162109) do

  create_table "abonos", force: :cascade do |t|
    t.integer "pago_id", null: false
    t.bigint "doc_pagos_id", null: false
    t.integer "nropago", null: false
    t.integer "factura_id", null: false
    t.bigint "doc_factura_id", null: false
    t.char "prefijo", limit: 6, null: false
    t.integer "nrofact", null: false
    t.bigint "concepto_id", null: false
    t.datetime "fechabono", null: false
    t.money "saldo", precision: 19, scale: 4, null: false
    t.money "abono", precision: 19, scale: 4, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_abonos_on_concepto_id"
    t.index ["doc_factura_id"], name: "index_abonos_on_doc_factura_id"
    t.index ["doc_pagos_id"], name: "index_abonos_on_doc_pagos_id"
    t.index ["usuario_id"], name: "index_abonos_on_usuario_id"
  end

  create_table "agencias", force: :cascade do |t|
    t.bigint "empresa_id", null: false
    t.char "nit", limit: 13, null: false
    t.varchar "nombre", limit: 80, null: false
    t.string "direccion", limit: 100, null: false
    t.string "telefono1", limit: 20, null: false
    t.string "telefono2", limit: 20
    t.string "contacto", limit: 20
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["empresa_id"], name: "index_agencias_on_empresa_id"
    t.index ["usuario_id"], name: "index_agencias_on_usuario_id"
  end

  create_table "anticipos", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.integer "factura_id"
    t.bigint "doc_factura_id"
    t.char "prefijo", limit: 6
    t.integer "nrofact"
    t.integer "pago_id", null: false
    t.bigint "doc_pagos_id", null: false
    t.integer "nropago", null: false
    t.datetime "fechatrn", null: false
    t.datetime "fechaven", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["doc_factura_id"], name: "index_anticipos_on_doc_factura_id"
    t.index ["doc_pagos_id"], name: "index_anticipos_on_doc_pagos_id"
    t.index ["entidad_id"], name: "index_anticipos_on_entidad_id"
    t.index ["usuario_id"], name: "index_anticipos_on_usuario_id"
  end

  create_table "articulos", force: :cascade do |t|
    t.bigint "grupo_id", null: false
    t.char "codigo", limit: 3, null: false
    t.varchar "nombre", limit: 50, null: false
    t.bigint "unidad_id", null: false
    t.money "preciomay", precision: 19, scale: 4
    t.money "preciodetal", precision: 19, scale: 4
    t.decimal "existenciamin", precision: 18, scale: 0, null: false
    t.decimal "existenciamax", precision: 18, scale: 0, null: false
    t.money "costo", precision: 19, scale: 4, null: false
    t.datetime "fechaultcompra"
    t.float "porcentajeIva", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["grupo_id"], name: "index_articulos_on_grupo_id"
    t.index ["unidad_id"], name: "index_articulos_on_unidad_id"
    t.index ["usuario_id"], name: "index_articulos_on_usuario_id"
  end

  create_table "bancos", force: :cascade do |t|
    t.string "nit", limit: 13
    t.varchar "nombre", limit: 80, null: false
    t.string "direccion", limit: 50
    t.bigint "ciudad_id", null: false
    t.string "telefono1", limit: 15
    t.string "telefono2", limit: 15
    t.string "contacto", limit: 50
    t.string "cuentaBancaria", limit: 15
    t.string "cuentaContable", limit: 15
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["ciudad_id"], name: "index_bancos_on_ciudad_id"
    t.index ["usuario_id"], name: "index_bancos_on_usuario_id"
  end

  create_table "barrios", force: :cascade do |t|
    t.bigint "zona_id", null: false
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_barrios_on_usuario_id"
    t.index ["zona_id"], name: "index_barrios_on_zona_id"
  end

  create_table "ciudades", force: :cascade do |t|
    t.bigint "pais_id", null: false
    t.varchar "nombre", limit: 80, null: false
    t.char "codigoDane", limit: 5
    t.char "codigoAlterno", limit: 5
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.bigint "departamento_id"
    t.index ["departamento_id"], name: "index_ciudades_on_departamento_id"
    t.index ["pais_id"], name: "index_ciudades_on_pais_id"
    t.index ["usuario_id"], name: "index_ciudades_on_usuario_id"
  end

  create_table "conceptos", force: :cascade do |t|
    t.bigint "servicio_id", null: false
    t.char "codigo", limit: 3, null: false
    t.varchar "nombre", limit: 50, null: false
    t.char "abreviatura", limit: 3, null: false
    t.float "porcentajeIva", null: false
    t.char "operacion", limit: 1, null: false
    t.char "clase", limit: 1
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["servicio_id"], name: "index_conceptos_on_servicio_id"
    t.index ["usuario_id"], name: "index_conceptos_on_usuario_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.bigint "pais_id"
    t.varchar "nombre", limit: 80, null: false
    t.char "codigo", limit: 5
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["pais_id"], name: "index_departamentos_on_pais_id"
    t.index ["usuario_id"], name: "index_departamentos_on_usuario_id"
  end

  create_table "descuentos", force: :cascade do |t|
    t.integer "pago_id", null: false
    t.bigint "documento_id", null: false
    t.integer "nropago", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["documento_id"], name: "index_descuentos_on_documento_id"
    t.index ["usuario_id"], name: "index_descuentos_on_usuario_id"
  end

  create_table "detalle_factura", force: :cascade do |t|
    t.integer "factura_id", null: false
    t.bigint "documento_id", null: false
    t.char "prefijo", limit: 6, null: false
    t.integer "nrofact", null: false
    t.bigint "concepto_id", null: false
    t.integer "cantidad", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.float "porcentajeIva", null: false
    t.money "iva", precision: 19, scale: 4, null: false
    t.string "observacion", limit: 300
    t.char "operacion", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_detalle_factura_on_concepto_id"
    t.index ["documento_id"], name: "index_detalle_factura_on_documento_id"
    t.index ["usuario_id"], name: "index_detalle_factura_on_usuario_id"
  end

  create_table "detalle_orden", force: :cascade do |t|
    t.integer "orden_id", null: false
    t.bigint "concepto_id", null: false
    t.integer "nrorden", null: false
    t.bigint "articulo_id"
    t.integer "cantidad", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.float "porcentajeIva", null: false
    t.money "iva", precision: 19, scale: 4, null: false
    t.money "costo", precision: 19, scale: 4, null: false
    t.string "observacion", limit: 300
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["articulo_id"], name: "index_detalle_orden_on_articulo_id"
    t.index ["concepto_id"], name: "index_detalle_orden_on_concepto_id"
    t.index ["usuario_id"], name: "index_detalle_orden_on_usuario_id"
  end

  create_table "dir_correspondencia", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.string "direccion", limit: 100, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["entidad_id"], name: "index_dir_correspondencia_on_entidad_id"
    t.index ["usuario_id"], name: "index_dir_correspondencia_on_usuario_id"
  end

  create_table "direcciones_dian", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.bigint "nomenclatura_id", null: false
    t.integer "nrox"
    t.string "letrax", limit: 3
    t.integer "nroy"
    t.string "letray", limit: 3
    t.integer "nroz"
    t.string "complemento", limit: 50
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["entidad_id"], name: "index_direcciones_dian_on_entidad_id"
    t.index ["nomenclatura_id"], name: "index_direcciones_dian_on_nomenclatura_id"
    t.index ["usuario_id"], name: "index_direcciones_dian_on_usuario_id"
  end

  create_table "direcciones_zonas", force: :cascade do |t|
    t.bigint "zona_id", null: false
    t.string "direccion", limit: 100, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_direcciones_zonas_on_usuario_id"
    t.index ["zona_id"], name: "index_direcciones_zonas_on_zona_id"
  end

  create_table "documentos", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.char "abreviatura", limit: 3, null: false
    t.char "clase", limit: 1
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_documentos_on_usuario_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.char "tipo", limit: 2, null: false
    t.char "nit", limit: 13, null: false
    t.varchar "razonsocial", limit: 80, null: false
    t.string "direccion", limit: 200, null: false
    t.string "telefono1", limit: 20, null: false
    t.string "telefono2", limit: 20
    t.bigint "ciudad_id", null: false
    t.bigint "entidad_id", null: false
    t.string "logo", limit: 100
    t.string "correo", limit: 50
    t.char "regimen", limit: 1
    t.char "contribuyente", limit: 1
    t.char "centrocosto", limit: 4
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["ciudad_id"], name: "index_empresas_on_ciudad_id"
    t.index ["entidad_id"], name: "index_empresas_on_entidad_id"
    t.index ["usuario_id"], name: "index_empresas_on_usuario_id"
  end

  create_table "entidades", force: :cascade do |t|
    t.bigint "funcion_id", null: false
    t.bigint "persona_id", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["funcion_id"], name: "index_entidades_on_funcion_id"
    t.index ["persona_id"], name: "index_entidades_on_persona_id"
    t.index ["usuario_id"], name: "index_entidades_on_usuario_id"
  end

  create_table "estados", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.char "abreviatura", limit: 3, null: false
    t.char "tipo", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.varchar "usuario", limit: 15, null: false
  end

  create_table "factura_orden", force: :cascade do |t|
    t.integer "factura_id", null: false
    t.bigint "documento_id", null: false
    t.char "prefijo", limit: 6, null: false
    t.integer "nrofact", null: false
    t.integer "orden_id", null: false
    t.bigint "concepto_id", null: false
    t.integer "nrorden", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_factura_orden_on_concepto_id"
    t.index ["documento_id"], name: "index_factura_orden_on_documento_id"
    t.index ["usuario_id"], name: "index_factura_orden_on_usuario_id"
  end

  create_table "facturacion", primary_key: ["documento_id", "prefijo", "nrofact"], force: :cascade do |t|
    t.integer "id", null: false
    t.bigint "entidad_id", null: false
    t.bigint "documento_id", null: false
    t.datetime "fechatrn", null: false
    t.datetime "fechaven", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.money "iva", precision: 19, scale: 4, null: false
    t.integer "dias", null: false
    t.char "prefijo", limit: 6, null: false
    t.integer "nrofact", null: false
    t.bigint "estado_id", null: false
    t.string "observacion", limit: 300
    t.char "reporta", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["documento_id"], name: "index_facturacion_on_documento_id"
    t.index ["entidad_id"], name: "index_facturacion_on_entidad_id"
    t.index ["estado_id"], name: "index_facturacion_on_estado_id"
    t.index ["usuario_id"], name: "index_facturacion_on_usuario_id"
  end

  create_table "formas_pago", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_formas_pago_on_usuario_id"
  end

  create_table "funciones", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_funciones_on_usuario_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.string "descripcion", limit: 80
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_grupos_on_usuario_id"
  end

  create_table "historial_tarifas", force: :cascade do |t|
    t.integer "tarifa_id", null: false
    t.bigint "zona_id", null: false
    t.bigint "concepto_id", null: false
    t.bigint "plan_id", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.datetime "fechainicio", null: false
    t.datetime "fechavence", null: false
    t.string "ccosto", limit: 4
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_historial_tarifas_on_concepto_id"
    t.index ["plan_id"], name: "index_historial_tarifas_on_plan_id"
    t.index ["usuario_id"], name: "index_historial_tarifas_on_usuario_id"
    t.index ["zona_id"], name: "index_historial_tarifas_on_zona_id"
  end

  create_table "info_internet", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.string "direccionip", limit: 20
    t.integer "velocidad"
    t.string "mac1", limit: 20
    t.string "mac2", limit: 20
    t.string "serialm", limit: 50
    t.string "marcam", limit: 50
    t.string "mascarasub", limit: 20
    t.string "dns", limit: 20
    t.string "gateway", limit: 20
    t.integer "nodo"
    t.string "clavewifi", limit: 50
    t.varchar "equipo", limit: 2
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["entidad_id"], name: "index_info_internet_on_entidad_id"
    t.index ["usuario_id"], name: "index_info_internet_on_usuario_id"
  end

  create_table "mvto_rorden", force: :cascade do |t|
    t.bigint "registro_orden_id", null: false
    t.integer "orden_id", null: false
    t.bigint "concepto_id", null: false
    t.integer "nrorden", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_mvto_rorden_on_concepto_id"
    t.index ["registro_orden_id"], name: "index_mvto_rorden_on_registro_orden_id"
    t.index ["usuario_id"], name: "index_mvto_rorden_on_usuario_id"
  end

  create_table "nomenclaturas", force: :cascade do |t|
    t.char "abreviatura", limit: 6, null: false
    t.string "descripcion", limit: 80
    t.integer "orden"
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_nomenclaturas_on_usuario_id"
  end

  create_table "notas", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.string "nota", limit: 300
    t.datetime "fecha", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["entidad_id"], name: "index_notas_on_entidad_id"
    t.index ["usuario_id"], name: "index_notas_on_usuario_id"
  end

  create_table "notas_fact", force: :cascade do |t|
    t.bigint "zona_id"
    t.datetime "fechaElaboracion", null: false
    t.datetime "fechaInicio", null: false
    t.datetime "fechaFin", null: false
    t.datetime "fechaVencimiento", null: false
    t.datetime "fechaCorte", null: false
    t.datetime "fechaPagosVen", null: false
    t.string "nota1", limit: 100
    t.string "nota2", limit: 100
    t.string "nota3", limit: 100
    t.string "nota4", limit: 100
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_notas_fact_on_usuario_id"
    t.index ["zona_id"], name: "index_notas_fact_on_zona_id"
  end

  create_table "ordenes", primary_key: ["concepto_id", "nrorden"], force: :cascade do |t|
    t.integer "id", null: false
    t.bigint "entidad_id", null: false
    t.bigint "concepto_id", null: false
    t.datetime "fechatrn", null: false
    t.datetime "fechaven", null: false
    t.integer "nrorden", null: false
    t.bigint "estado_id", null: false
    t.string "observacion", limit: 300
    t.bigint "tecnico_id", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_ordenes_on_concepto_id"
    t.index ["entidad_id"], name: "index_ordenes_on_entidad_id"
    t.index ["estado_id"], name: "index_ordenes_on_estado_id"
    t.index ["tecnico_id"], name: "index_ordenes_on_tecnico_id"
    t.index ["usuario_id"], name: "index_ordenes_on_usuario_id"
  end

  create_table "pagos", primary_key: ["documento_id", "nropago"], force: :cascade do |t|
    t.integer "id", null: false
    t.bigint "entidad_id", null: false
    t.bigint "documento_id", null: false
    t.integer "nropago", null: false
    t.datetime "fechatrn", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.bigint "estado_id", null: false
    t.string "observacion", limit: 300
    t.bigint "forma_pago_id", null: false
    t.bigint "banco_id", null: false
    t.bigint "cobrador_id", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["banco_id"], name: "index_pagos_on_banco_id"
    t.index ["cobrador_id"], name: "index_pagos_on_cobrador_id"
    t.index ["documento_id"], name: "index_pagos_on_documento_id"
    t.index ["entidad_id"], name: "index_pagos_on_entidad_id"
    t.index ["estado_id"], name: "index_pagos_on_estado_id"
    t.index ["forma_pago_id"], name: "index_pagos_on_forma_pago_id"
    t.index ["usuario_id"], name: "index_pagos_on_usuario_id"
  end

  create_table "paises", force: :cascade do |t|
    t.varchar "nombre", limit: 80, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_paises_on_usuario_id"
  end

  create_table "parametros", force: :cascade do |t|
    t.string "descripcion", limit: 100
    t.string "valor", limit: 100
  end

  create_table "permanencias", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.datetime "fechaDcto", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["entidad_id"], name: "index_permanencias_on_entidad_id"
    t.index ["usuario_id"], name: "index_permanencias_on_usuario_id"
  end

  create_table "personas", force: :cascade do |t|
    t.bigint "tipo_documento_id", null: false
    t.string "documento", limit: 15, null: false
    t.varchar "nombre1", limit: 50, null: false
    t.varchar "nombre2", limit: 50
    t.varchar "apellido1", limit: 50, null: false
    t.varchar "apellido2", limit: 50
    t.string "direccion", limit: 200, null: false
    t.bigint "barrio_id", null: false
    t.bigint "zona_id", null: false
    t.bigint "ciudad_id"
    t.string "telefono1", limit: 20
    t.string "telefono2", limit: 20
    t.string "correo", limit: 50
    t.datetime "fechanac"
    t.char "tipopersona", limit: 1, null: false
    t.integer "estrato"
    t.char "condicionfisica", limit: 1, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["barrio_id"], name: "index_personas_on_barrio_id"
    t.index ["ciudad_id"], name: "index_personas_on_ciudad_id"
    t.index ["tipo_documento_id"], name: "index_personas_on_tipo_documento_id"
    t.index ["usuario_id"], name: "index_personas_on_usuario_id"
    t.index ["zona_id"], name: "index_personas_on_zona_id"
  end

  create_table "planes", force: :cascade do |t|
    t.bigint "servicio_id", null: false
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["servicio_id"], name: "index_planes_on_servicio_id"
    t.index ["usuario_id"], name: "index_planes_on_usuario_id"
  end

  create_table "plantilla_fact", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.bigint "concepto_id"
    t.bigint "estado_id", null: false
    t.bigint "tarifa_id"
    t.datetime "fechaini", null: false
    t.datetime "fechafin", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_plantilla_fact_on_concepto_id"
    t.index ["entidad_id"], name: "index_plantilla_fact_on_entidad_id"
    t.index ["estado_id"], name: "index_plantilla_fact_on_estado_id"
    t.index ["tarifa_id"], name: "index_plantilla_fact_on_tarifa_id"
    t.index ["usuario_id"], name: "index_plantilla_fact_on_usuario_id"
  end

  create_table "polit_permanencia", force: :cascade do |t|
    t.integer "permanencia", null: false
    t.char "medida", limit: 1, null: false
    t.string "cantidad1", limit: 5
    t.string "cantidad2", limit: 5
    t.string "cantidad3", limit: 5
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_polit_permanencia_on_usuario_id"
  end

  create_table "registro_orden", force: :cascade do |t|
    t.varchar "nombre", limit: 100, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_registro_orden_on_usuario_id"
  end

  create_table "resoluciones", force: :cascade do |t|
    t.bigint "empresa_id", null: false
    t.string "nroResolucion", limit: 20, null: false
    t.string "tipo", limit: 20, null: false
    t.string "prefijo", limit: 4, null: false
    t.string "rangoRI", limit: 20, null: false
    t.string "rangoRF", limit: 20, null: false
    t.integer "rangoI", null: false
    t.integer "rangoF", null: false
    t.datetime "fechainicio", null: false
    t.datetime "fechavence", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["empresa_id"], name: "index_resoluciones_on_empresa_id"
    t.index ["usuario_id"], name: "index_resoluciones_on_usuario_id"
  end

  create_table "senales", force: :cascade do |t|
    t.bigint "entidad_id", null: false
    t.string "contrato", limit: 20, null: false
    t.string "direccion", limit: 200, null: false
    t.string "urbanizacion", limit: 200
    t.string "torre", limit: 20
    t.string "apto", limit: 20
    t.bigint "barrio_id", null: false
    t.bigint "zona_id", null: false
    t.string "telefono1", limit: 20
    t.string "telefono2", limit: 20
    t.string "contacto", limit: 20
    t.integer "estrato"
    t.char "vivienda", limit: 1
    t.string "observacion", limit: 200
    t.datetime "fechacontrato", null: false
    t.integer "permanencia"
    t.integer "televisores"
    t.integer "decos"
    t.string "precinto", limit: 10
    t.bigint "vendedor_id", null: false
    t.bigint "tipo_instalacion_id", null: false
    t.bigint "tecnologia_id", null: false
    t.char "tiposervicio", limit: 1
    t.char "areainstalacion", limit: 1
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.bigint "tipo_facturacion_id"
    t.index ["barrio_id"], name: "index_senales_on_barrio_id"
    t.index ["entidad_id"], name: "index_senales_on_entidad_id"
    t.index ["tecnologia_id"], name: "index_senales_on_tecnologia_id"
    t.index ["tipo_facturacion_id"], name: "index_senales_on_tipo_facturacion_id"
    t.index ["tipo_instalacion_id"], name: "index_senales_on_tipo_instalacion_id"
    t.index ["usuario_id"], name: "index_senales_on_usuario_id"
    t.index ["vendedor_id"], name: "index_senales_on_vendedor_id"
    t.index ["zona_id"], name: "index_senales_on_zona_id"
  end

  create_table "servicios", force: :cascade do |t|
    t.varchar "nombre", limit: 20, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_servicios_on_usuario_id"
  end

  create_table "tarifas", force: :cascade do |t|
    t.bigint "zona_id", null: false
    t.bigint "concepto_id", null: false
    t.bigint "plan_id", null: false
    t.money "valor", precision: 19, scale: 4, null: false
    t.bigint "estado_id", null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["concepto_id"], name: "index_tarifas_on_concepto_id"
    t.index ["estado_id"], name: "index_tarifas_on_estado_id"
    t.index ["plan_id"], name: "index_tarifas_on_plan_id"
    t.index ["usuario_id"], name: "index_tarifas_on_usuario_id"
    t.index ["zona_id"], name: "index_tarifas_on_zona_id"
  end

  create_table "tecnologias", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_tecnologias_on_usuario_id"
  end

  create_table "tipo_documentos", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_tipo_documentos_on_usuario_id"
  end

  create_table "tipo_facturacion", force: :cascade do |t|
    t.varchar "nombre", limit: 30, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_tipo_facturacion_on_usuario_id"
  end

  create_table "tipo_instalaciones", force: :cascade do |t|
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_tipo_instalaciones_on_usuario_id"
  end

  create_table "traslados", force: :cascade do |t|
    t.integer "orden_id", null: false
    t.bigint "concepto_id", null: false
    t.integer "nrorden", null: false
    t.bigint "zonaAnt_id", null: false
    t.bigint "barrioAnt_id", null: false
    t.string "direccionAnt", limit: 200, null: false
    t.bigint "zonaNue_id", null: false
    t.bigint "barrioNue_id", null: false
    t.string "direccionNue", limit: 200, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["barrioAnt_id"], name: "index_traslados_on_barrioAnt_id"
    t.index ["barrioNue_id"], name: "index_traslados_on_barrioNue_id"
    t.index ["concepto_id"], name: "index_traslados_on_concepto_id"
    t.index ["usuario_id"], name: "index_traslados_on_usuario_id"
    t.index ["zonaAnt_id"], name: "index_traslados_on_zonaAnt_id"
    t.index ["zonaNue_id"], name: "index_traslados_on_zonaNue_id"
  end

  create_table "unidades", force: :cascade do |t|
    t.string "descripcion", limit: 80
    t.char "unidad", limit: 3
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_unidades_on_usuario_id"
  end

  create_table "usuario_menu", primary_key: ["modulo", "opcion", "usuario_id"], force: :cascade do |t|
    t.varchar "modulo", limit: 50, null: false
    t.varchar "opcion", limit: 50, null: false
    t.bigint "usuario_id", null: false
    t.char "ver", limit: 5, null: false
    t.varchar "titulo", limit: 50
    t.index ["usuario_id"], name: "index_usuario_menu_on_usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "login", limit: 15, null: false
    t.varchar "nombre", limit: 50, null: false
    t.string "password_digest"
    t.string "token"
    t.char "nivel", limit: 1
    t.bigint "estado_id"
    t.char "tipoImpresora", limit: 1
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.varchar "usuariocre", null: false
    t.index ["estado_id"], name: "index_usuarios_on_estado_id"
  end

  create_table "zonas", force: :cascade do |t|
    t.bigint "ciudad_id", null: false
    t.varchar "nombre", limit: 50, null: false
    t.datetime "fechacre", default: -> { "getdate()" }, null: false
    t.datetime "fechacam", default: -> { "getdate()" }, null: false
    t.bigint "usuario_id", null: false
    t.index ["ciudad_id"], name: "index_zonas_on_ciudad_id"
    t.index ["usuario_id"], name: "index_zonas_on_usuario_id"
  end

  add_foreign_key "abonos", "conceptos"
  add_foreign_key "abonos", "documentos", column: "doc_factura_id"
  add_foreign_key "abonos", "documentos", column: "doc_pagos_id"
  add_foreign_key "abonos", "facturacion", column: "doc_factura_id", primary_key: "documento_id", name: "FK_facturas"
  add_foreign_key "abonos", "facturacion", column: "nrofact", primary_key: "nrofact", name: "FK_facturas"
  add_foreign_key "abonos", "facturacion", column: "prefijo", primary_key: "prefijo", name: "FK_facturas"
  add_foreign_key "abonos", "pagos", column: "doc_pagos_id", primary_key: "documento_id", name: "FK_pagos"
  add_foreign_key "abonos", "pagos", column: "nropago", primary_key: "nropago", name: "FK_pagos"
  add_foreign_key "abonos", "usuarios"
  add_foreign_key "agencias", "empresas"
  add_foreign_key "agencias", "usuarios"
  add_foreign_key "anticipos", "documentos", column: "doc_factura_id"
  add_foreign_key "anticipos", "documentos", column: "doc_pagos_id"
  add_foreign_key "anticipos", "entidades"
  add_foreign_key "anticipos", "facturacion", column: "doc_factura_id", primary_key: "documento_id", name: "FK_anticipos_facturas"
  add_foreign_key "anticipos", "facturacion", column: "nrofact", primary_key: "nrofact", name: "FK_anticipos_facturas"
  add_foreign_key "anticipos", "facturacion", column: "prefijo", primary_key: "prefijo", name: "FK_anticipos_facturas"
  add_foreign_key "anticipos", "pagos", column: "doc_pagos_id", primary_key: "documento_id", name: "FK_anticipos_pagos"
  add_foreign_key "anticipos", "pagos", column: "nropago", primary_key: "nropago", name: "FK_anticipos_pagos"
  add_foreign_key "anticipos", "usuarios"
  add_foreign_key "articulos", "grupos"
  add_foreign_key "articulos", "unidades"
  add_foreign_key "articulos", "usuarios"
  add_foreign_key "bancos", "ciudades"
  add_foreign_key "bancos", "usuarios"
  add_foreign_key "barrios", "usuarios"
  add_foreign_key "barrios", "zonas"
  add_foreign_key "ciudades", "departamentos"
  add_foreign_key "ciudades", "paises"
  add_foreign_key "ciudades", "usuarios"
  add_foreign_key "conceptos", "servicios"
  add_foreign_key "conceptos", "usuarios"
  add_foreign_key "departamentos", "paises"
  add_foreign_key "departamentos", "usuarios"
  add_foreign_key "descuentos", "documentos"
  add_foreign_key "descuentos", "pagos", column: "documento_id", primary_key: "documento_id", name: "FK_descuentos_pagos"
  add_foreign_key "descuentos", "pagos", column: "nropago", primary_key: "nropago", name: "FK_descuentos_pagos"
  add_foreign_key "descuentos", "usuarios"
  add_foreign_key "detalle_factura", "conceptos"
  add_foreign_key "detalle_factura", "documentos"
  add_foreign_key "detalle_factura", "facturacion", column: "documento_id", primary_key: "documento_id", name: "FK_facturacion"
  add_foreign_key "detalle_factura", "facturacion", column: "nrofact", primary_key: "nrofact", name: "FK_facturacion"
  add_foreign_key "detalle_factura", "facturacion", column: "prefijo", primary_key: "prefijo", name: "FK_facturacion"
  add_foreign_key "detalle_factura", "usuarios"
  add_foreign_key "detalle_orden", "articulos"
  add_foreign_key "detalle_orden", "conceptos"
  add_foreign_key "detalle_orden", "ordenes", column: "concepto_id", primary_key: "concepto_id", name: "FK_ordenes"
  add_foreign_key "detalle_orden", "ordenes", column: "nrorden", primary_key: "nrorden", name: "FK_ordenes"
  add_foreign_key "detalle_orden", "usuarios"
  add_foreign_key "dir_correspondencia", "entidades"
  add_foreign_key "dir_correspondencia", "usuarios"
  add_foreign_key "direcciones_dian", "entidades"
  add_foreign_key "direcciones_dian", "nomenclaturas"
  add_foreign_key "direcciones_dian", "usuarios"
  add_foreign_key "direcciones_zonas", "usuarios"
  add_foreign_key "direcciones_zonas", "zonas"
  add_foreign_key "documentos", "usuarios"
  add_foreign_key "empresas", "ciudades"
  add_foreign_key "empresas", "entidades"
  add_foreign_key "empresas", "usuarios"
  add_foreign_key "entidades", "funciones"
  add_foreign_key "entidades", "personas"
  add_foreign_key "entidades", "usuarios"
  add_foreign_key "factura_orden", "conceptos"
  add_foreign_key "factura_orden", "documentos"
  add_foreign_key "factura_orden", "facturacion", column: "documento_id", primary_key: "documento_id", name: "FK_factorden_facturas"
  add_foreign_key "factura_orden", "facturacion", column: "nrofact", primary_key: "nrofact", name: "FK_factorden_facturas"
  add_foreign_key "factura_orden", "facturacion", column: "prefijo", primary_key: "prefijo", name: "FK_factorden_facturas"
  add_foreign_key "factura_orden", "ordenes", column: "concepto_id", primary_key: "concepto_id", name: "FK_factorden_ordenes"
  add_foreign_key "factura_orden", "ordenes", column: "nrorden", primary_key: "nrorden", name: "FK_factorden_ordenes"
  add_foreign_key "factura_orden", "usuarios"
  add_foreign_key "facturacion", "documentos"
  add_foreign_key "facturacion", "entidades"
  add_foreign_key "facturacion", "estados"
  add_foreign_key "facturacion", "usuarios"
  add_foreign_key "formas_pago", "usuarios"
  add_foreign_key "funciones", "usuarios"
  add_foreign_key "grupos", "usuarios"
  add_foreign_key "historial_tarifas", "conceptos"
  add_foreign_key "historial_tarifas", "planes"
  add_foreign_key "historial_tarifas", "usuarios"
  add_foreign_key "historial_tarifas", "zonas"
  add_foreign_key "info_internet", "entidades"
  add_foreign_key "info_internet", "usuarios"
  add_foreign_key "mvto_rorden", "conceptos"
  add_foreign_key "mvto_rorden", "ordenes", column: "concepto_id", primary_key: "concepto_id", name: "FK_mvtororden_ordenes"
  add_foreign_key "mvto_rorden", "ordenes", column: "nrorden", primary_key: "nrorden", name: "FK_mvtororden_ordenes"
  add_foreign_key "mvto_rorden", "registro_orden"
  add_foreign_key "mvto_rorden", "usuarios"
  add_foreign_key "nomenclaturas", "usuarios"
  add_foreign_key "notas", "entidades"
  add_foreign_key "notas", "usuarios"
  add_foreign_key "notas_fact", "usuarios"
  add_foreign_key "notas_fact", "zonas"
  add_foreign_key "ordenes", "conceptos"
  add_foreign_key "ordenes", "entidades"
  add_foreign_key "ordenes", "entidades", column: "tecnico_id"
  add_foreign_key "ordenes", "estados"
  add_foreign_key "ordenes", "usuarios"
  add_foreign_key "pagos", "bancos"
  add_foreign_key "pagos", "documentos"
  add_foreign_key "pagos", "entidades"
  add_foreign_key "pagos", "entidades", column: "cobrador_id"
  add_foreign_key "pagos", "estados"
  add_foreign_key "pagos", "formas_pago"
  add_foreign_key "pagos", "usuarios"
  add_foreign_key "paises", "usuarios"
  add_foreign_key "permanencias", "entidades"
  add_foreign_key "permanencias", "usuarios"
  add_foreign_key "personas", "barrios"
  add_foreign_key "personas", "ciudades"
  add_foreign_key "personas", "tipo_documentos"
  add_foreign_key "personas", "usuarios"
  add_foreign_key "personas", "zonas"
  add_foreign_key "planes", "servicios"
  add_foreign_key "planes", "usuarios"
  add_foreign_key "plantilla_fact", "conceptos"
  add_foreign_key "plantilla_fact", "entidades"
  add_foreign_key "plantilla_fact", "estados"
  add_foreign_key "plantilla_fact", "tarifas"
  add_foreign_key "plantilla_fact", "usuarios"
  add_foreign_key "polit_permanencia", "usuarios"
  add_foreign_key "registro_orden", "usuarios"
  add_foreign_key "resoluciones", "empresas"
  add_foreign_key "resoluciones", "usuarios"
  add_foreign_key "senales", "barrios"
  add_foreign_key "senales", "entidades"
  add_foreign_key "senales", "entidades", column: "vendedor_id"
  add_foreign_key "senales", "tecnologias"
  add_foreign_key "senales", "tipo_facturacion"
  add_foreign_key "senales", "tipo_instalaciones"
  add_foreign_key "senales", "usuarios"
  add_foreign_key "senales", "zonas"
  add_foreign_key "servicios", "usuarios"
  add_foreign_key "tarifas", "conceptos"
  add_foreign_key "tarifas", "estados"
  add_foreign_key "tarifas", "planes"
  add_foreign_key "tarifas", "usuarios"
  add_foreign_key "tarifas", "zonas"
  add_foreign_key "tecnologias", "usuarios"
  add_foreign_key "tipo_documentos", "usuarios"
  add_foreign_key "tipo_facturacion", "usuarios"
  add_foreign_key "tipo_instalaciones", "usuarios"
  add_foreign_key "traslados", "barrios", column: "barrioAnt_id"
  add_foreign_key "traslados", "barrios", column: "barrioNue_id"
  add_foreign_key "traslados", "conceptos"
  add_foreign_key "traslados", "ordenes", column: "concepto_id", primary_key: "concepto_id", name: "FK_traslados_ordenes"
  add_foreign_key "traslados", "ordenes", column: "nrorden", primary_key: "nrorden", name: "FK_traslados_ordenes"
  add_foreign_key "traslados", "usuarios"
  add_foreign_key "traslados", "zonas", column: "zonaAnt_id"
  add_foreign_key "traslados", "zonas", column: "zonaNue_id"
  add_foreign_key "unidades", "usuarios"
  add_foreign_key "usuario_menu", "usuarios"
  add_foreign_key "usuarios", "estados"
  add_foreign_key "zonas", "ciudades"
  add_foreign_key "zonas", "usuarios"
end
