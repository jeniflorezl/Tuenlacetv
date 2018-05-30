class Senal < ApplicationRecord
  extend NombreMeses

  belongs_to :entidad
  belongs_to :barrio
  belongs_to :zona
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  belongs_to :usuario
  belongs_to :tipo_facturacion

  before_save :setting

  validates :entidad, :contrato, :direccion, :telefono1, :barrio, :zona, :fechacontrato,
  :tipo_instalacion, :tecnologia, :tiposervicio, :usuario, :tipo_facturacion, presence: true #obligatorio

  @t = Time.now
  @mes = Senal.mes(@t.strftime("%B"))
  @consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados ordenes').valor
  @estadoD = Estado.find_by(abreviatura: 'PE').id
  @estadoU = Estado.find_by(abreviatura: 'P').id

  def setting
    self.direccion.upcase!
    self.urbanizacion.upcase! unless self.urbanizacion.blank?
    self.torre.upcase! unless self.torre.blank?
    self.apto.upcase! unless self.apto.blank?
    self.vivienda.upcase!
    self.tiposervicio.upcase!
    self.areainstalacion.upcase!
    self.televisores = 0 if self.televisores == nil
    self.decos = 0 if self.decos == nil
  end

  private

  def self.afiliacion_tv(senal, entidad, valorAfiTv, valorDcto, tarifaTv, tecnico)
    ultimo = 0
    conceptord = Concepto.find(10)
    conceptoplant = Concepto.find(3)
    conceptofact = Concepto.find(1)
    doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
    estado_pag = Estado.find_by(abreviatura: 'PA').id
    plantilla = PlantillaFact.new(entidad_id: entidad.id, concepto_id: conceptoplant.id, estado_id: @estadoU, tarifa_id: tarifaTv, 
      fechaini: senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: senal.usuario_id)
    if plantilla.save
      if @consecutivos == 'S'
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id = #{conceptord.id};
        SQL
      else
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes;
        SQL
      end
      Senal.connection.clear_query_cache
      ultimo = Senal.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo = 1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      orden = Orden.new(entidad_id: entidad.id, concepto_id: conceptord.id, fechatrn: senal.fechacontrato,
        fechaven: senal.fechacontrato, nrorden: ultimo, estado_id: @estadoD, observacion: 'REGISTRO CREADO EN PROCESO DE AFILIACIÓN',
        tecnico_id: tecnico, usuario_id: senal.usuario_id)
      if orden.save
        query = <<-SQL 
        SELECT id FROM ordenes WHERE nrorden = #{orden.nrorden} and concepto_id = #{conceptord.id};
        SQL
        Senal.connection.clear_query_cache
        orden_id = Senal.connection.select_all(query)
        orden_id = (orden_id[0]["id"]).to_i
        MvtoRorden.create(registro_orden_id: 1, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: senal.fechacontrato, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 2, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: senal.usuario_id, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 3, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: tecnico, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 11, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: 'OFICINA', usuario_id: senal.usuario_id)
        if senal.decos > 0
          estado_aplicado = Estado.find_by(abreviatura: 'AP').id
          estado_activo = Estado.find_by(abreviatura: 'A').id
          concepto_decos = Concepto.find(27)
          plan_tv = Plan.find_by(nombre: 'TELEVISION').id
          tarifa_decos = Tarifa.where("zona_id = #{senal.zona_id} and concepto_id = #{concepto_decos.id} and plan_id = #{plan_tv}")
          if @consecutivos == 'S'
            query = <<-SQL 
            SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id = #{concepto_decos.id};
            SQL
          else
            query = <<-SQL 
            SELECT MAX(nrorden) as ultimo FROM ordenes;
            SQL
          end
          Senal.connection.clear_query_cache
          ultimo = Senal.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          orden_decos = Orden.new(entidad_id: entidad.id, concepto_id: concepto_decos.id, fechatrn: senal.fechacontrato,
            fechaven: senal.fechacontrato, nrorden: ultimo, estado_id: estado_aplicado, observacion: concepto_decos.nombre,
            tecnico_id: tecnico, usuario_id: senal.usuario_id)
          if orden_decos.save
            query = <<-SQL 
            SELECT id FROM ordenes WHERE nrorden = #{orden_decos.nrorden} and concepto_id = #{concepto_decos.id};
            SQL
            Senal.connection.clear_query_cache
            orden_decos_id = Senal.connection.select_all(query)
            orden_decos_id = (orden_decos_id[0]["id"]).to_i
            MvtoRorden.create(registro_orden_id: 1, orden_id: orden_decos_id, concepto_id: orden_decos.concepto_id,
              nrorden: orden_decos.nrorden, valor: senal.fechacontrato, usuario_id: senal.usuario_id)
            MvtoRorden.create(registro_orden_id: 2, orden_id: orden_decos_id, concepto_id: orden_decos.concepto_id,
              nrorden: orden_decos.nrorden, valor: senal.usuario_id, usuario_id: senal.usuario_id)
            MvtoRorden.create(registro_orden_id: 3, orden_id: orden_decos_id, concepto_id: orden_decos.concepto_id,
              nrorden: orden_decos.nrorden, valor: tecnico, usuario_id: senal.usuario_id)
            MvtoRorden.create(registro_orden_id: 11, orden_id: orden_decos_id, concepto_id: orden_decos.concepto_id,
              nrorden: orden_decos.nrorden, valor: 'OFICINA', usuario_id: senal.usuario_id)
            plantilla_decos = PlantillaFact.new(entidad_id: entidad.id, concepto_id: concepto_decos.id, estado_id: estado_activo, tarifa_id: tarifa_decos[0]["id"], 
              fechaini: senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: senal.usuario_id)
            unless plantilla_decos.save
              return false
            end
          else
            return false
          end
        end
        if valorAfiTv > 0
          pref = Resolucion.last.prefijo
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Senal.connection.clear_query_cache
          ultimo = Senal.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          iva_cpto = conceptofact.porcentajeIva
          if iva_cpto > 0
            valor_sin_iva = valorAfiTv / (iva_cpto / 100 + 1)
            iva = valorAfiTv - valor_sin_iva
            valor = valor_sin_iva
          end
          factura = Facturacion.new(entidad_id: entidad.id, documento_id: doc, fechatrn: senal.fechacontrato,
            fechaven: senal.fechacontrato, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
            estado_id: @estadoD, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id: senal.usuario_id)
          if factura.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{factura.nrofact} and documento_id = #{doc};
            SQL
            Senal.connection.clear_query_cache
            factura_id = Senal.connection.select_all(query)
            factura_id = (factura_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: factura_id, documento_id: factura.documento_id, 
              prefijo: factura.prefijo, nrofact: factura.nrofact, concepto_id: conceptofact.id, cantidad: 1, 
              valor: factura.valor, porcentajeIva: iva_cpto, iva: iva, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN' + ' ' + @mes,
              operacion: '+', usuario_id: factura.usuario_id)
            if detallef.save
              if valorDcto > 0
                valor_total_fact = factura.valor + iva
                doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                query = <<-SQL 
                SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                SQL
                Senal.connection.clear_query_cache
                ultimo = Senal.connection.select_all(query)
                if ultimo[0]["ultimo"] == nil
                  ultimo = 1
                else
                  ultimo = (ultimo[0]["ultimo"]).to_i + 1
                end
                pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: senal.fechacontrato,
                  valor: valorDcto, estado_id: estado_pag, observacion: 'DESCUENTO SUSCRIPCION', forma_pago_id: 1,
                  banco_id: 1, usuario_id: senal.usuario_id)
                if pago.save
                  query = <<-SQL 
                  SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                  SQL
                  Senal.connection.clear_query_cache
                  pago_id = Senal.connection.select_all(query)
                  pago_id = (pago_id[0]["id"]).to_i
                  abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                    factura_id: factura_id, doc_factura_id: factura.documento_id, prefijo: factura.prefijo, 
                    nrofact: factura.nrofact, concepto_id: detallef.concepto_id, fechabono: senal.fechacontrato, 
                    saldo: valor_total_fact, abono: pago.valor, usuario_id: pago.usuario_id)
                  unless abono.save
                    return false
                  end
                else
                  return false
                end
              end
              return true
            else
              return false
            end
          else
            return false
          end 
        else   
          return true
        end
      else
        return false
      end
    else
      return false
    end
  end


  def self.afiliacion_int(senal, entidad, valorAfiInt, valorDcto, tarifaInt, tecnico)
    ultimo = 0
    conceptord = Concepto.find(11)
    conceptoplant = Concepto.find(4)
    conceptofact = Concepto.find(2)
    doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
    estado_pag = Estado.find_by(abreviatura: 'PA').id
    plantillaint = PlantillaFact.new(entidad_id: entidad.id, concepto_id: conceptoplant.id, estado_id: @estadoU, tarifa_id: tarifaInt, 
      fechaini: senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: senal.usuario_id)
    if plantillaint.save
      if @consecutivos == 'S'
        query = <<-SQL  
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id = #{conceptord.id};
        SQL
      else
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes;
        SQL
      end
      Senal.connection.clear_query_cache
      ultimo = Senal.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo = 1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      ordenin = Orden.new(entidad_id: entidad.id, concepto_id: conceptord.id, fechatrn: senal.fechacontrato,
      fechaven: senal.fechacontrato, nrorden: ultimo, estado_id: @estadoD, observacion: 'REGISTRO CREADO EN PROCESO DE AFILIACIÓN',
      tecnico_id: tecnico, usuario_id: senal.usuario_id)
      if ordenin.save
        query = <<-SQL 
        SELECT id FROM ordenes WHERE nrorden = #{ordenin.nrorden} and concepto_id = #{conceptord.id};
        SQL
        Senal.connection.clear_query_cache
        ordenin_id = Senal.connection.select_all(query)
        ordenin_id = (ordenin_id[0]["id"]).to_i
        MvtoRorden.create(registro_orden_id: 1, orden_id: ordenin_id, concepto_id: ordenin.concepto_id,
          nrorden: ordenin.nrorden, valor: senal.fechacontrato, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 2, orden_id: ordenin_id, concepto_id: ordenin.concepto_id,
          nrorden: ordenin.nrorden, valor: senal.usuario_id, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 3, orden_id: ordenin_id, concepto_id: ordenin.concepto_id,
          nrorden: ordenin.nrorden, valor: tecnico, usuario_id: senal.usuario_id)
        MvtoRorden.create(registro_orden_id: 11, orden_id: ordenin_id, concepto_id: ordenin.concepto_id,
          nrorden: ordenin.nrorden, valor: 'OFICINA', usuario_id: senal.usuario_id)
        if valorAfiInt > 0
          pref = Resolucion.last.prefijo
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Senal.connection.clear_query_cache
          ultimo = Senal.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          iva_cpto = conceptofact.porcentajeIva
          if iva_cpto > 0
            valor_sin_iva = valorAfiInt / (iva_cpto / 100 + 1)
            iva = valorAfiInt - valor_sin_iva
            valor = valor_sin_iva
          end
          facturain = Facturacion.new(entidad_id: entidad.id, documento_id: doc, fechatrn: senal.fechacontrato,
            fechaven: senal.fechacontrato, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
            estado_id: @estadoD, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET', reporta: '0', usuario_id: senal.usuario_id)
          if facturain.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturain.nrofact} and documento_id = #{doc};
            SQL
            Senal.connection.clear_query_cache
            facturain_id = Senal.connection.select_all(query)
            facturain_id = (facturain_id[0]["id"]).to_i
            detallefin = DetalleFactura.new(factura_id: facturain_id, documento_id: facturain.documento_id, 
              prefijo: facturain.prefijo, nrofact: facturain.nrofact, concepto_id: conceptofact.id, cantidad: 1, 
              valor: facturain.valor, porcentajeIva: iva_cpto, iva: iva, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET' + ' ' + @mes,
              operacion: '+', usuario_id: facturain.usuario_id)
            if detallefin.save
              if valorDcto > 0
                valor_total_fact = facturain.valor + iva
                doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                query = <<-SQL 
                SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                SQL
                Senal.connection.clear_query_cache
                ultimo = Senal.connection.select_all(query)
                if ultimo[0]["ultimo"] == nil
                  ultimo = 1
                else
                  ultimo = (ultimo[0]["ultimo"]).to_i + 1
                end
                pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: senal.fechacontrato,
                  valor: valorDcto, estado_id: estado_pag, observacion: 'DESCUENTO SUSCRIPCION', forma_pago_id: 1,
                  banco_id: 1, usuario_id: senal.usuario_id)
                if pago.save
                  query = <<-SQL 
                  SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                  SQL
                  Senal.connection.clear_query_cache
                  pago_id = Senal.connection.select_all(query)
                  pago_id = (pago_id[0]["id"]).to_i
                  abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                    factura_id: facturain_id, doc_factura_id: facturain.documento_id, prefijo: facturain.prefijo, 
                    nrofact: facturain.nrofact, concepto_id: detallefin.concepto_id, fechabono: senal.fechacontrato, 
                    saldo: valor_total_fact, abono: pago.valor, usuario_id: pago.usuario_id)
                  unless abono.save
                    return false
                  end
                else
                  return false
                end
              end
              return true
            else
              return false
            end
          else
            return false
          end
        else
          return true
        end
      else
        return false
      end
    else
      return false
    end
  end

  def self.eliminar_suscriptor(entidad, persona, senal, info_internet, plantilla_tv, plantilla_decos, plantilla_int)
    query = <<-SQL 
    SELECT TOP 1 * FROM pagos WHERE entidad_id = #{entidad.id};
    SQL
    Senal.connection.clear_query_cache
    pago = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT TOP 1 * FROM facturacion WHERE entidad_id = #{entidad.id};
    SQL
    Senal.connection.clear_query_cache
    factura = Senal.connection.select_all(query)
    if pago.blank? && factura.blank?
      if plantilla_tv
          plantilla_tv.destroy_all()
      end
      if plantilla_decos
        plantilla_decos.destroy_all()
      end
      query = <<-SQL
      SELECT id FROM ordenes WHERE entidad_id = #{entidad.id}; 
      SQL
      orden_id = Senal.connection.select_all(query)
      unless orden_id.blank?
        orden_id.each do |o|
          query = <<-SQL
          DELETE detalle_orden WHERE orden_id = #{o["id"]}; 
          DELETE mvto_rorden WHERE orden_id = #{o["id"]};
          DELETE ordenes WHERE entidad_id = #{entidad.id} and id = #{o["id"]};
          SQL
          Senal.connection.select_all(query)
        end
      end
      if info_internet
          info_internet.destroy()
          if plantilla_int
            plantilla_int.destroy_all()
          end
      end
      senal.destroy()
      entidad.destroy()
      persona.destroy()
      return true
    else
      return false
    end
  end

  def self.senales_consol(fecha_ini, fecha_fin)
    senales_array = Array.new
    f_ini = Date.parse fecha_ini.to_s
    f_fin = Date.parse fecha_fin.to_s
    senales = Senal.where("fechacontrato >= '#{f_ini}' and fechacontrato <= '#{f_fin}'")
    query = <<-SQL 
    SELECT * FROM VwSenales WHERE funcion_id = 1;
    SQL
    #query = <<-SQL 
    #SELECT * FROM VwSenales WHERE funcion_id = 1 and year(fechacontrato) >= #{ano_ini} and
    #year(fechacontrato) <= #{ano_fin} and month(fechacontrato) >= #{mes_ini} and 
    #month(fechacontrato) <= #{mes_fin} and day(fechacontrato) >= #{dia_ini} and
    #day(fechacontrato) <= #{dia_fin};
    #SQL
    Senal.connection.clear_query_cache
    senal = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 10 or concepto_id = 11;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 6 or concepto_id = 7;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 12 or concepto_id = 13;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 14 or concepto_id = 15;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    i = 0
    senal.each do |s|
      senales.each do |sen|
        if s["id"] == sen.entidad_id
          if s["tv"] == "1"
            instalacion = ''
            corte = ''
            traslado = ''
            reconexion = ''
            instalaciones.each do |inst|
                if inst["concepto_id"] == 10 && inst["entidad_id"] == s["id"]
                    instalacion = inst["fechaven"]
                end
            end
            cortes.each do |c|
                if c["concepto_id"] == 6 && c["entidad_id"] == s["id"]
                    corte = c["fechaven"]
                end
            end
            traslados.each do |t|
                if t["concepto_id"] == 12 && t["entidad_id"] == s["id"]
                    traslado = t["fechaven"]
                end
            end
            reconexiones.each do |rco|
                if rco["concepto_id"] == 14 && rco["entidad_id"] == s["id"]
                    reconexion = rco["fechaven"]
                end
            end
          end
          if s["internet"] == "1"
            instalacion_int = ''
            corte_int = ''
            traslado_int = ''
            reconexion_int = ''
            instalaciones.each do |inst|
              if inst["concepto_id"] == 11 && inst["entidad_id"] == s["id"]
                instalacion_int = inst["fechaven"]
              end
            end
            cortes.each do |c|
              if c["concepto_id"] == 7 && c["entidad_id"] == s["id"]
                corte_int = c["fechaven"]
              end
            end
            traslados.each do |t|
              if t["concepto_id"] == 13 && t["entidad_id"] == s["id"]
                traslado_int = t["fechaven"]
              end
            end
            reconexiones.each do |rco|
              if rco["concepto_id"] == 15 && rco["entidad_id"] == s["id"]
                reconexion_int = rco["fechaven"]
              end
            end
          end
          senales_array[i] = { 'id' => s["id"], 'documento' => s["documento"],
            'nombres' => s["nombres"], 'direccion' => s["direccion"], 'barrio' => s["barrio"],
            'zona' => s["zona"], 'telefono1' => s["telefono1"], 'fechacontrato' => s["fechacontrato"],
            'fecha_ult_pago' => s["fecha_ult_pago"], 'estado_tv' => s["estado_tv"], 'saldo_tv' => s["saldo_tv"],
            'estado_int' => s["estado_int"], 'saldo_int' => s["saldo_int"], 'instalacion_tv' => instalacion,
            'corte_tv' => corte, 'traslado_tv' => traslado, 'reco_tv' => reconexion, 'instalacion_int' => instalacion_int, 
            'corte_int' => corte_int, 'traslado_int' => traslado_int, 'rco_int' => reconexion_int }
          i += 1
        end
      end
    end
    senales_array
  end

  def self.senales_tv(fecha_ini, fecha_fin)
    senales_array = Array.new
    instalacion = ''
    corte = ''
    traslado = ''
    reconexion = ''
    f_ini = Date.parse fecha_ini.to_s
    f_fin = Date.parse fecha_fin.to_s
    senales = Senal.where("fechacontrato >= '#{f_ini}' and fechacontrato <= '#{f_fin}'")
    query = <<-SQL 
    SELECT * FROM VwSenales WHERE funcion_id = 1 and tv = 1;
    SQL
    #query = <<-SQL 
    #SELECT * FROM VwSenales WHERE funcion_id = 1 and year(fechacontrato) >= #{ano_ini} and
    #year(fechacontrato) <= #{ano_fin} and month(fechacontrato) >= #{mes_ini} and 
    #month(fechacontrato) <= #{mes_fin} and day(fechacontrato) >= #{dia_ini} and
    #day(fechacontrato) <= #{dia_fin};
    #SQL
    Senal.connection.clear_query_cache
    senal = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 10;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 6;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 12;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 14;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    i = 0
    senal.each do |s|
      senales.each do |sen|
        if s["id"] == sen.entidad_id
          instalaciones.each do |inst|
              if inst["concepto_id"] == 10 && inst["entidad_id"] == s["id"]
                  instalacion = inst["fechaven"]
              end
          end
          cortes.each do |c|
              if c["concepto_id"] == 6 && c["entidad_id"] == s["id"]
                  corte = c["fechaven"]
              end
          end
          traslados.each do |t|
              if t["concepto_id"] == 12 && t["entidad_id"] == s["id"]
                  traslado = t["fechaven"]
              end
          end
          reconexiones.each do |rco|
              if rco["concepto_id"] == 14 && rco["entidad_id"] == s["id"]
                  reconexion = rco["fechaven"]
              end
          end
          senales_array[i] = { 'id' => s["id"], 'documento' => s["documento"],
            'nombres' => s["nombres"], 'direccion' => s["direccion"], 'barrio' => s["barrio"],
            'zona' => s["zona"], 'telefono1' => s["telefono1"], 'fechacontrato' => s["fechacontrato"],
            'fecha_ult_pago' => s["fecha_ult_pago"], 'estado_tv' => s["estado_tv"], 'saldo_tv' => s["saldo_tv"],
            'estado_int' => s["estado_int"], 'saldo_int' => s["saldo_int"], 'instalacion_tv' => instalacion,
            'corte_tv' => corte, 'traslado_tv' => traslado, 'reco_tv' => reconexion }
          i += 1
        end
      end
    end
    senales_array
  end

  def self.senales_int(fecha_ini, fecha_fin)
    senales_array = Array.new
    instalacion_int = ''
    corte_int = ''
    traslado_int = ''
    reconexion_int = ''
    f_ini = Date.parse fecha_ini.to_s
    f_fin = Date.parse fecha_fin.to_s
    senales = Senal.where("fechacontrato >= '#{f_ini}' and fechacontrato <= '#{f_fin}'")
    query = <<-SQL 
    SELECT * FROM VwSenales WHERE funcion_id = 1 and internet = 1;
    SQL
    #query = <<-SQL 
    #SELECT * FROM VwSenales WHERE funcion_id = 1 and year(fechacontrato) >= #{ano_ini} and
    #year(fechacontrato) <= #{ano_fin} and month(fechacontrato) >= #{mes_ini} and 
    #month(fechacontrato) <= #{mes_fin} and day(fechacontrato) >= #{dia_ini} and
    #day(fechacontrato) <= #{dia_fin};
    #SQL
    Senal.connection.clear_query_cache
    senal = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 11;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 7;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 13;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 15;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    i = 0
    senal.each do |s|
      senales.each do |sen|
        if s["id"] == sen.entidad_id
          instalaciones.each do |inst|
            if inst["concepto_id"] == 11 && inst["entidad_id"] == s["id"]
              instalacion_int = inst["fechaven"]
            end
          end
          cortes.each do |c|
            if c["concepto_id"] == 7 && c["entidad_id"] == s["id"]
              corte_int = c["fechaven"]
            end
          end
          traslados.each do |t|
            if t["concepto_id"] == 13 && t["entidad_id"] == s["id"]
              traslado_int = t["fechaven"]
            end
          end
          reconexiones.each do |rco|
            if rco["concepto_id"] == 15 && rco["entidad_id"] == s["id"]
              reconexion_int = rco["fechaven"]
            end
          end
          senales_array[i] = { 'id' => s["id"], 'documento' => s["documento"],
            'nombres' => s["nombres"], 'direccion' => s["direccion"], 'barrio' => s["barrio"],
            'zona' => s["zona"], 'telefono1' => s["telefono1"], 'fechacontrato' => s["fechacontrato"],
            'fecha_ult_pago' => s["fecha_ult_pago"], 'estado_tv' => s["estado_tv"], 'saldo_tv' => s["saldo_tv"],
            'estado_int' => s["estado_int"], 'saldo_int' => s["saldo_int"], 'instalacion_int' => instalacion_int, 
            'corte_int' => corte_int, 'traslado_int' => traslado_int, 'rco_int' => reconexion_int }
          i += 1
        end
      end
    end
    senales_array
  end
end
