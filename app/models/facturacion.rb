class Facturacion < ApplicationRecord
  require 'date'
  extend NombreMeses
  extend FormatoFecha

  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :documento, :fechatrn, :fechaven, :valor, :iva, :dias, :prefijo, :nrofact,
  :estado, :reporta, :usuario, presence: true #obligatorio

  private

  def self.facturaciones_generadas
    fact_generadas = Array.new
    i = 0
    ban = 0
    notas_fact = NotaFact.all
    notas_fact.each do |nota|
      fecha_ela = nota["fechaElaboracion"]
      if  i == 1 && fecha_ela == fact_generadas[i-1]['f_elaboracion']
        ban = 1
      end
      if ban != 1
        fecha_ela = Date.parse fecha_ela.to_s
        fecha1 = Facturacion.formato_fecha(fecha_ela)
        fecha_inicio = nota["fechaInicio"]
        fecha2 = Facturacion.formato_fecha(fecha_inicio)
        fecha_fin = nota["fechaFin"]
        fecha_fin = Date.parse fecha_fin.to_s
        fecha3 = Facturacion.formato_fecha(fecha_fin)
        fecha_ven = nota["fechaVencimiento"]
        fecha4 = Facturacion.formato_fecha(fecha_ven)
        documento = Documento.find_by(nombre: 'FACTURA DE VENTA').id
        query = <<-SQL 
        SELECT nrofact FROM facturacion WHERE fechatrn >= '#{fecha_ela}' and fechaven <= '#{fecha_fin}' and documento_id = #{documento} ORDER BY id;
        SQL
        Facturacion.connection.clear_query_cache
        factura = Facturacion.connection.select_all(query)
        fact_ini = factura.first
        nrofact_ini = fact_ini["nrofact"]
        fact_fin = factura.last
        nrofact_fin = fact_fin["nrofact"]
        fact_generadas[i] = { 'nrofact_ini' => nrofact_ini, 'nrofact_fin' => nrofact_fin, 'f_elaboracion' => fecha1,
        'f_inicio' => fecha2, 'f_fin' => fecha3, 'f_ven' => fecha4}
        i += 1
      end
    end
    fact_generadas
  end

  def self.generar_facturacion(tipo_fact, f_elaboracion, f_inicio, f_fin, f_vence, f_corte, 
    f_vencidos, observa, zona, usuario_id)
    byebug
    observa = observa.upcase! unless observa == observa.upcase
    fech_e = f_elaboracion.split('/')
    resp = 0
    resp1 = 0
    respuesta = 0
    notasfact = NotaFact.where("year(fechaElaboracion) = #{fech_e[2]} and month(fechaElaboracion) = #{fech_e[1]}")
    unless notasfact.blank?
      if notasfact[0]["zona_id"] == nil && zona == 'Todos'
        return respuesta = 3
      elsif notasfact[0]["zona_id"] == zona.to_i
        return respuesta = 4
      else
        zonas = Zona.all
        zonas.each do |z|
          notasfact.each do |row|
            if row["zona_id"] == z.id
              resp = 1
            end
          end
          if resp == 1
            if zona == z.id
              resp1 = 1
            end
          end
        end
      end
    end
    if resp1 == 1
      return respuesta = 4
    else
      documentos = Parametro.find_by(descripcion: 'Maneja internet en documentos separado')
      concepto_tv = Concepto.find(3)
      concepto_int = Concepto.find(4)
      concepto_decos = Concepto.find(51)
      iva_int = concepto_int.porcentajeIva
      iva = 0
      estado = Estado.find_by(abreviatura: 'A').id
      fecha1 = ''
      fecha2 = ''
      pref = Resolucion.last.prefijo
      estado_pend = Estado.find_by(abreviatura: 'PE').id
      estado_pag = Estado.find_by(abreviatura: 'PA').id
      doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
      serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
      serv_int = Servicio.find_by(nombre: 'INTERNET').id
      f_fact = Time.new(fech_e[2], fech_e[1], fech_e[0])
      nombre_mes = Facturacion.mes(f_fact.strftime("%B"))
      ban = 0
      fact_vent_id = 0
      fact_vent_valor = 0
      fact_vent_iva = 0
      fact_vent_documento_id = 0
      fact_vent_prefijo = 0
      fact_vent_nrofact = 0
      facturacion_id = 0
      if zona == 'Todos'
        senales = Senal.where(tipo_facturacion_id: tipo_fact)
        nota_f = NotaFact.new(fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
        unless nota_f.save
          return respuesta = 2
        end
      else
        senales = Senal.where("tipo_facturacion_id = #{tipo_fact} and zona_id = #{zona}")
        nota_f = NotaFact.new(zona_id: zona, fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
        unless nota_f.save
          return respuesta = 2
        end
      end
      fecha1 = Date.parse f_fin
      mes = fecha1.month
      ano = fecha1.year
      if documentos.valor == 'S'
        senales.each do |senal|
          byebug
          facturacion = ''
          pagado = false
          plantillas = PlantillaFact.where("concepto_id <> #{concepto_int.id} and entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            byebug
            ban = 0
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                concepto = Concepto.find(plantilla.concepto_id)
                iva = concepto.porcentajeIva
                observacion_d = concepto.nombre
                if concepto.id == concepto_tv.id
                  observacion_d = 'TELEVISION'
                end
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_tv = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    byebug
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    detallefact.each do |d|
                      byebug
                      if d["concepto_id"] == concepto.id
                        fact_tv = 1
                        break
                      end
                      j += 1
                    end
                    if fact_tv == 1
                      break
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_tv != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if concepto.id == concepto_decos.id
                    decos = senal.decos
                    valor_mens = valor_mens * decos
                  end
                  if iva > 0
                    valor_sin_iva = valor_mens / (iva / 100 + 1)
                    iva_fact = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
                  SQL
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  if facturacion.blank?
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva_fact, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estado_pend, observacion: observa, reporta: '1', usuario_id: usuario_id)
                    if facturacion.save
                      query = <<-SQL 
                      SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                      SQL
                      Facturacion.connection.clear_query_cache
                      facturacion_id = Facturacion.connection.select_all(query)
                      facturacion_id = (facturacion_id[0]["id"]).to_i
                    else
                      return respuesta = 2
                    end
                    fact_vent_id = facturacion_id
                    fact_vent_valor = facturacion.valor
                    fact_vent_iva = facturacion.iva
                    fact_vent_documento_id = facturacion.documento_id
                    fact_vent_prefijo = facturacion.prefijo
                    fact_vent_nrofact = facturacion.nrofact
                  else
                    query = <<-SQL 
                    UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva_fact} WHERE id = #{facturacion_id};
                    SQL
                    Facturacion.connection.select_all(query)
                    fact_vent_valor += valor_mens
                    fact_vent_iva += iva_fact
                  end
                  detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                    valor: valor_mens, porcentajeIva: iva, iva: iva_fact, observacion: observacion_d + ' ' + nombre_mes,
                    operacion: '+', usuario_id: usuario_id)
                  unless detallef.save
                    return respuesta = 2
                  end
                  if senal.entidad.persona.condicionfisica == 'D'
                    valor_total_fact = valor_mens + iva
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_total_fact * (porcentaje.to_f / 100)
                    doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                    query = <<-SQL 
                    SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                    SQL
                    Facturacion.connection.clear_query_cache
                    ultimo = Facturacion.connection.select_all(query)
                    if ultimo[0]["ultimo"] == nil
                      ultimo = 1
                    else
                      ultimo = (ultimo[0]["ultimo"]).to_i + 1
                    end
                    pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: f_elaboracion,
                      valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                      banco_id: 1, usuario_id: usuario_id)
                    if pago.save
                      query = <<-SQL 
                      SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                      SQL
                      Facturacion.connection.clear_query_cache
                      pago_id = Facturacion.connection.select_all(query)
                      pago_id = (pago_id[0]["id"]).to_i
                      saldo_ab = facturacion.valor + facturacion.iva
                      abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                        factura_id: facturacion_id, doc_factura_id: facturacion.documento_id,
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id,
                        fechabono: f_elaboracion, saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                      unless abono.save
                        return respuesta = 2
                      end
                    else
                      return respuesta = 2
                    end
                  end
                else
                  fecha3 = Date.parse factura[i]["fechaven"].to_s
                  dias_fact = (fecha1 - fecha3).to_i
                  if dias_fact > 0
                    valor_dia = tarifa / 30
                    valor_mens_detalle = valor_dia * dias_fact
                    dias_fact = factura[i]["dias"] + dias_fact
                    valor_fact = (detallefact[j]["valor"] + detallefact[j]["iva"]) + valor_mens_detalle
                    valor_fact = (valor_fact.to_f).round
                    if dias_fact > 30 
                      dias_fact = 30
                    end
                    if valor_fact > tarifa
                      valor_mens_detalle = valor_fact - tarifa
                    end
                    if iva > 0
                      valor_sin_iva = valor_mens_detalle / (iva / 100 + 1)
                      iva_fact = valor_mens_detalle - valor_sin_iva
                      valor_mens_detalle = valor_sin_iva
                    end
                    valor_mens_detalle = (valor_mens_detalle.to_f).round
                    iva_fact = (iva_fact.to_f).round
                    if factura[i]["estado_id"] == estado_pag
                      saldo = (factura[i]["valor"] + valor_mens_detalle) + (factura[i]["iva"] + iva_fact)
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva}, iva = iva + #{iva_fact}, observacion = '#{observacion_d}' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto.id};
                      UPDATE abonos set saldo = #{saldo} WHERE factura_id = #{factura[i]["id"]};
                      SQL
                    else
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva}, iva = iva + #{iva_fact}, observacion = '#{observacion_d}' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto.id};
                      SQL
                    end
                    Facturacion.connection.select_all(query)
                    fact_vent_id = factura[i]["id"]
                    fact_vent_valor = factura[i]["valor"] + valor_mens_detalle
                    fact_vent_iva = factura[i]["iva"] + iva_fact
                    fact_vent_documento_id = factura[i]["documento_id"]
                    fact_vent_prefijo = factura[i]["prefijo"]
                    fact_vent_nrofact = factura[i]["nrofact"]
                  end
                end
                if concepto.id == concepto_tv.id
                  query = <<-SQL 
                  SELECT * FROM anticipos WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_tv};
                  SQL
                  Facturacion.connection.clear_query_cache
                  anticipo = Facturacion.connection.select_all(query)
                  unless anticipo.blank?
                    if anticipo[0]["factura_id"] == nil
                      valor_total = fact_vent_valor + fact_vent_iva
                      if anticipo[0]["valor"] >= valor_total
                        pagado = true
                      else
                        pagado = false
                      end
                      query = <<-SQL 
                      UPDATE anticipos set factura_id = #{fact_vent_id}, doc_factura_id = #{fact_vent_documento_id}, prefijo = '#{fact_vent_prefijo}', nrofact = #{fact_vent_nrofact} WHERE id = #{anticipo[0]["id"]};
                      SQL
                      Facturacion.connection.select_all(query)
                      query = <<-SQL 
                      SELECT * FROM VwPagosAnticipados WHERE entidad_id = #{senal.entidad_id};
                      SQL
                      Facturacion.connection.clear_query_cache
                      pago_id = Facturacion.connection.select_all(query)
                      query = <<-SQL 
                      SELECT * FROM anticipos WHERE nropago = #{pago_id[0]["nropago"]};
                      SQL
                      Facturacion.connection.clear_query_cache
                      ant_pagos = Facturacion.connection.select_all(query)
                      ult_ant = ant_pagos.last
                      if ult_ant["id"] == anticipo[0]["id"]
                        query = <<-SQL 
                        UPDATE pagos set estado_id = #{estado_pag} WHERE pago_id = #{anticipo[0]["pago_id"]};
                        SQL
                        Facturacion.connection.select_all(query)
                      end
                    end
                  end
                else
                  pagado = false
                end
              end
            end
          end
          if pagado == true
            query = <<-SQL 
            UPDATE facturacion set estado_id = #{estado_pag} WHERE id = #{fact_vent_id};
            SQL
            Facturacion.connection.select_all(query)
          end
        end
        senales.each do |senal|
          byebug
          plantillas = PlantillaFact.where("concepto_id = #{concepto_int.id} and entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            ban = 0
            byebug
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_int = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    detallefact.each do |d|
                      if d["concepto_id"] == concepto_int.id
                        fact_int = 1
                        break
                      end
                      j += 1
                    end
                    if fact_int == 1
                      break
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_int != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if iva_int > 0
                    valor_sin_iva = valor_mens / (iva_int / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
                  SQL
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc, fechatrn: f_elaboracion,
                    fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                    estado_id: estado_pend, observacion: observa, reporta: '1', usuario_id: usuario_id)
                  if facturacion.save
                    query = <<-SQL 
                    SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                    SQL
                    Facturacion.connection.clear_query_cache
                    facturacion_id = Facturacion.connection.select_all(query)
                    facturacion_id = (facturacion_id[0]["id"]).to_i
                    detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_int.id, cantidad: 1, 
                    valor: facturacion.valor, porcentajeIva: iva_int, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
                    operacion: '+', usuario_id: usuario_id)
                    unless detallef.save
                      return respuesta = 2
                    end
                    fact_vent_id = facturacion_id
                    fact_vent_valor = facturacion.valor
                    fact_vent_iva = facturacion.iva
                    fact_vent_documento_id = facturacion.documento_id
                    fact_vent_prefijo = facturacion.prefijo
                    fact_vent_nrofact = facturacion.nrofact
                  else
                    return respuesta = 2
                  end
                else
                  fecha3 = Date.parse factura[i]["fechaven"].to_s
                  dias_fact = (fecha1 - fecha3).to_i
                  if dias_fact > 0
                    valor_dia = tarifa / 30
                    valor_mens_detalle = valor_dia * dias_fact
                    dias_fact = factura[i]["dias"] + dias_fact
                    valor_fact = (detallefact[j]["valor"] + detallefact[j]["iva"]) + valor_mens_detalle
                    valor_fact = (valor_fact.to_f).round
                    if dias_fact > 30 
                      dias_fact = 30
                    end
                    if valor_fact > tarifa
                      valor_mens_detalle = valor_fact - tarifa
                    end
                    if iva_int > 0
                      valor_sin_iva = valor_mens_detalle / (iva_int / 100 + 1)
                      iva_fact = valor_mens_detalle - valor_sin_iva
                      valor_mens_detalle = valor_sin_iva
                    end
                    valor_mens_detalle = (valor_mens_detalle.to_f).round
                    iva_fact = (iva_fact.to_f).round
                    if factura[i]["estado_id"] == estado_pag
                      saldo = (factura[i]["valor"] + valor_mens_detalle) + (factura[i]["iva"] + iva_fact)
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva_int}, iva = iva + #{iva_fact}, observacion = 'INTERNET' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto_int.id};
                      UPDATE abonos set saldo = #{saldo} WHERE factura_id = #{factura[i]["id"]};
                      SQL
                    else
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva_int}, iva = iva + #{iva_fact}, observacion = 'INTERNET' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto_int.id};
                      SQL
                    end
                    Facturacion.connection.select_all(query)
                    fact_vent_id = factura[i]["id"]
                    fact_vent_valor = factura[i]["valor"] + valor_mens_detalle
                    fact_vent_iva = factura[i]["iva"] + iva_fact
                    fact_vent_documento_id = factura[i]["documento_id"]
                    fact_vent_prefijo = factura[i]["prefijo"]
                    fact_vent_nrofact = factura[i]["nrofact"]
                  end
                end
              end
            end
          end
          query = <<-SQL 
          SELECT * FROM anticipos WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_int};
          SQL
          Facturacion.connection.clear_query_cache
          anticipo = Facturacion.connection.select_all(query)
          unless anticipo.blank?
            if anticipo[0]["factura_id"] == nil
              valor_total = fact_vent_valor + fact_vent_iva
              if anticipo[0]["valor"] >= valor_total
                query = <<-SQL 
                UPDATE anticipos set factura_id = #{fact_vent_id}, doc_factura_id = #{fact_vent_documento_id}, prefijo = '#{fact_vent_prefijo}', nrofact = #{fact_vent_nrofact} WHERE id = #{anticipo[0]["id"]};
                UPDATE facturacion set estado_id = #{estado_pag} WHERE id = #{fact_vent_id};
                SQL
              else
                query = <<-SQL 
                UPDATE anticipos set factura_id = #{fact_vent_id}, doc_factura_id = #{fact_vent_documento_id}, prefijo = '#{fact_vent_prefijo}', nrofact = #{fact_vent_nrofact} WHERE id = #{anticipo[0]["id"]};
                SQL
              end
              Facturacion.connection.select_all(query)
              query = <<-SQL 
              SELECT * FROM VwPagosAnticipados WHERE entidad_id = #{senal.entidad_id};
              SQL
              Facturacion.connection.clear_query_cache
              pago_id = Facturacion.connection.select_all(query)
              query = <<-SQL 
              SELECT * FROM anticipos WHERE nropago = #{pago_id[0]["nropago"]};
              SQL
              Facturacion.connection.clear_query_cache
              ant_pagos = Facturacion.connection.select_all(query)
              ult_ant = ant_pagos.last
              if ult_ant["id"] == anticipo[0]["id"]
                query = <<-SQL 
                UPDATE pagos set estado_id = #{estado_pag} WHERE pago_id = #{anticipo[0]["pago_id"]};
                SQL
                Facturacion.connection.select_all(query)
              end
            end
          end
        end
      else
        senales.each do |senal|
          byebug
          facturacion = ''
          pagado = false
          plantillas = PlantillaFact.where("entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            byebug
            ban = 0
            concepto = Concepto.find(plantilla.concepto_id)
            observacion_d = concepto.nombre
            iva_cpto = concepto.porcentajeIva
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_concepto = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    detallefact.each do |d|
                      if d["concepto_id"] == concepto.id
                        fact_concepto = 1
                        break
                      end
                      j += 1
                    end
                    if fact_concepto == 1
                      break
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_concepto != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if concepto.id == concepto_decos.id
                    decos = senal.decos
                    valor_mens = valor_mens * decos
                  end
                  if concepto.id == concepto_tv.id
                    observacion_d = 'TELEVISION'
                  elsif concepto.id == concepto_int.id
                    observacion_d = 'INTERNET'
                  end
                  if iva_cpto > 0
                    valor_sin_iva = valor_mens / (iva_cpto / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
                  SQL
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  if facturacion.blank?
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estado_pend, observacion: observa, reporta: '1', usuario_id: usuario_id)
                    if facturacion.save
                      query = <<-SQL 
                      SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                      SQL
                      Facturacion.connection.clear_query_cache
                      facturacion_id = Facturacion.connection.select_all(query)
                      facturacion_id = (facturacion_id[0]["id"]).to_i
                    else
                      return respuesta = 2
                    end
                    fact_vent_id = facturacion_id
                    fact_vent_valor = facturacion.valor
                    fact_vent_iva = facturacion.iva
                    fact_vent_documento_id = facturacion.documento_id
                    fact_vent_prefijo = facturacion.prefijo
                    fact_vent_nrofact = facturacion.nrofact
                  else
                    query = <<-SQL 
                    UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva} WHERE id = #{facturacion_id};
                    SQL
                    Facturacion.connection.select_all(query)
                    fact_vent_valor += valor_mens
                    fact_vent_iva += iva
                  end
                  detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                  prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                  valor: valor_mens, porcentajeIva: iva_cpto, iva: iva, observacion: observacion_d + ' ' + nombre_mes,
                  operacion: '+', usuario_id: usuario_id)
                  unless detallef.save
                    return respuesta = 2
                  end
                  if concepto.id == concepto_tv.id
                    valor_total_fact = valor_mens + iva
                    if senal.entidad.persona.condicionfisica == 'D'
                      porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                      descuento = valor_total_fact * (porcentaje.to_f / 100)
                      doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                      query = <<-SQL 
                      SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                      SQL
                      Facturacion.connection.clear_query_cache
                      ultimo = Facturacion.connection.select_all(query)
                      if ultimo[0]["ultimo"] == nil
                        ultimo = 1
                      else
                        ultimo = (ultimo[0]["ultimo"]).to_i + 1
                      end
                      pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: f_elaboracion,
                        valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                        banco_id: 1, usuario_id: usuario_id)
                      if pago.save
                        query = <<-SQL 
                        SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                        SQL
                        Facturacion.connection.clear_query_cache
                        pago_id = Facturacion.connection.select_all(query)
                        pago_id = (pago_id[0]["id"]).to_i
                        saldo_ab = facturacion.valor + facturacion.iva
                        abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                          factura_id: facturacion_id, doc_factura_id: facturacion.documento_id,
                          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id,
                          fechabono: f_elaboracion, saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                        unless abono.save
                          return respuesta = 2
                        end
                      else
                        return respuesta = 2
                      end
                    end
                  end
                else
                  fecha3 = Date.parse factura[i]["fechaven"].to_s
                  dias_fact = (fecha1 - fecha3).to_i
                  if dias_fact > 0
                    valor_dia = tarifa / 30
                    valor_mens_detalle = valor_dia * dias_fact
                    dias_fact = factura[i]["dias"] + dias_fact
                    valor_fact = (detallefact[j]["valor"] + detallefact[j]["iva"]) + valor_mens_detalle
                    valor_fact = (valor_fact.to_f).round
                    if dias_fact > 30 
                      dias_fact = 30
                    end
                    if valor_fact > tarifa
                      valor_mens_detalle = valor_fact - tarifa
                    end
                    if iva_cpto > 0
                      valor_sin_iva = valor_mens_detalle / (iva_cpto / 100 + 1)
                      iva_fact = valor_mens_detalle - valor_sin_iva
                      valor_mens_detalle = valor_sin_iva
                    end
                    valor_mens_detalle = (valor_mens_detalle.to_f).round
                    iva_fact = (iva_fact.to_f).round
                    if factura[i]["estado_id"] == estado_pag
                      saldo = (factura[i]["valor"] + valor_mens_detalle) + (factura[i]["iva"] + iva_fact)
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva_cpto}, iva = iva + #{iva_fact}, observacion = '#{observacion_d}' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto.id};
                      UPDATE abonos set saldo = #{saldo} WHERE factura_id = #{factura[i]["id"]};
                      SQL
                    else
                      query = <<-SQL 
                      UPDATE facturacion set valor = valor + #{valor_mens_detalle}, iva = iva + #{iva_fact}, dias = #{dias_fact}, estado_id = #{estado_pend}, observacion = '#{observa}' WHERE id = #{factura[i]["id"]};
                      UPDATE detalle_factura set valor = valor + #{valor_mens_detalle}, porcentajeIva = #{iva_cpto}, iva = iva + #{iva_fact}, observacion = '#{observacion_d}' + ' ' + '#{nombre_mes}' WHERE factura_id = #{factura[i]["id"]} and concepto_id = #{concepto.id};
                      SQL
                    end
                    Facturacion.connection.select_all(query)
                    fact_vent_id = factura[i]["id"]
                    fact_vent_valor = factura[i]["valor"] + valor_mens_detalle
                    fact_vent_iva = factura[i]["iva"] + iva_fact
                    fact_vent_documento_id = factura[i]["documento_id"]
                    fact_vent_prefijo = factura[i]["prefijo"]
                    fact_vent_nrofact = factura[i]["nrofact"]
                  end
                end
                if concepto.id == concepto_tv.id || concepto.id == concepto_int.id
                  if concepto.id == concepto_tv.id
                    query = <<-SQL 
                    SELECT * FROM anticipos WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_tv};
                    SQL
                  else
                    query = <<-SQL 
                    SELECT * FROM anticipos WHERE entidad_id = #{senal.entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_int};
                    SQL
                  end
                  Facturacion.connection.clear_query_cache
                  anticipo = Facturacion.connection.select_all(query)
                  unless anticipo.blank?
                    if anticipo[0]["factura_id"] == nil
                      valor_total = fact_vent_valor + fact_vent_iva
                      if anticipo[0]["valor"] >= valor_total
                        pagado = true
                      else
                        pagado = false
                      end
                      query = <<-SQL 
                      UPDATE anticipos set factura_id = #{fact_vent_id}, doc_factura_id = #{fact_vent_documento_id}, prefijo = '#{fact_vent_prefijo}', nrofact = #{fact_vent_nrofact} WHERE id = #{anticipo[0]["id"]};
                      SQL
                      Facturacion.connection.select_all(query)
                      query = <<-SQL 
                      SELECT * FROM VwPagosAnticipados WHERE entidad_id = #{senal.entidad_id};
                      SQL
                      Facturacion.connection.clear_query_cache
                      pago_id = Facturacion.connection.select_all(query)
                      query = <<-SQL 
                      SELECT * FROM anticipos WHERE nropago = #{pago_id[0]["nropago"]};
                      SQL
                      Facturacion.connection.clear_query_cache
                      ant_pagos = Facturacion.connection.select_all(query)
                      ult_ant = ant_pagos.last
                      if ult_ant["id"] == anticipo[0]["id"]
                        query = <<-SQL 
                        UPDATE pagos set estado_id = #{estado_pag} WHERE pago_id = #{anticipo[0]["pago_id"]};
                        SQL
                        Facturacion.connection.select_all(query)
                      end
                    end
                  end
                else
                  pagado = false
                end
              end
            end
          end
          if pagado == true
            query = <<-SQL 
            UPDATE facturacion set estado_id = #{estado_pag} WHERE id = #{fact_vent_id};
            SQL
            Facturacion.connection.select_all(query)
          end
        end
      end
      return respuesta = 1
    end
  end

  def self.factura_manual(tipo_facturacion, servicio_id, f_elaboracion, f_inicio, f_fin, 
    f_vencimiento, entidad_id, valor_fact, observa, usuario_id)
    byebug
    respuesta = 0
    observa = observa.upcase! unless observa == observa.upcase
    t = Time.now
    nombre_mes = Facturacion.mes(t.strftime("%B"))
    fecha_inicio = f_inicio.split('/')
    fecha_actual_m = t.strftime "%m"
    fecha_actual_a = t.strftime "%Y"
    if fecha_inicio[2] == fecha_actual_a && fecha_inicio[1] == fecha_actual_m
      entidad = Entidad.find(entidad_id)
      fecha1 = Date.parse f_inicio
      fecha2 = Date.parse f_fin
      mes = fecha1.month
      ano = fecha1.year
      concepto_tv = Concepto.find(3)
      iva_tv = concepto_tv.porcentajeIva
      concepto_int = Concepto.find(4)
      iva_int = concepto_int.porcentajeIva
      fact = 0
      detallefact = ''
      doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
      serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
      serv_int = Servicio.find_by(nombre: 'INTERNET').id
      pref = Resolucion.last.prefijo
      estado_pend = Estado.find_by(abreviatura: 'PE').id
      estado_pag = Estado.find_by(abreviatura: 'PA').id
      parametro = Parametro.find_by(descripcion: 'Permite facturas manuales mayor a la tarifa').valor
      ban = 0
      ban1 = 0
      query = <<-SQL 
      SELECT * FROM facturacion WHERE entidad_id = #{entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
      SQL
      Facturacion.connection.clear_query_cache
      factura = Facturacion.connection.select_all(query)
      if parametro == 'N'
        ban = 1
      end
      if servicio_id == serv_tv
        plantilla = PlantillaFact.find_by(entidad_id: entidad_id, concepto_id: concepto_tv.id)
        tarifa = plantilla.tarifa.valor
        i = 0
        j = 0
        unless factura.blank?
          factura.each do |row|
            detallefact = DetalleFactura.where(nrofact: row["nrofact"])
            if detallefact[0]["concepto_id"] == concepto_tv.id
              fact = 1
              j = i
            end
            i += 1
          end
        end
        if fact != 1
          if ban == 1
            if valor_fact <= tarifa
              ban1 = 1
            end
          else
            ban1 = 1
          end
        else
          valor_f = factura[j]["valor"] + factura[j]["iva"]
          valor_t = valor_f + valor_fact
          if ban == 1
            if valor_t <= tarifa
              ban1 = 1
            end
          else
            ban1 = 1
          end
        end
        if ban1 == 1
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Facturacion.connection.clear_query_cache
          ultimo = Facturacion.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          dias = (fecha2 - fecha1).to_i + 1
          if dias < 30
            if fecha1.month == 2
              dias = 30
            end
          end
          if iva_tv > 0
            valor_sin_iva = valor_fact / (iva_tv / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: f_elaboracion,
            fechaven: f_vencimiento, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: estado_pend, observacion: observa, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
            SQL
            Facturacion.connection.clear_query_cache
            facturacion_id = Facturacion.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_tv.id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            unless detallef.save
              return respuesta = 2
            end
          else
            return respuesta = 2
          end
        else
          return respuesta = 4
        end
        if entidad.persona.condicionfisica == 'D'
          valor_total_fact = valor_fact + iva
          porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
          descuento = valor_total_fact * (porcentaje.to_f / 100)
          doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
          query = <<-SQL 
          SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
          SQL
          Facturacion.connection.clear_query_cache
          ultimo = Facturacion.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          pago = Pago.new(entidad_id: entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: f_elaboracion,
            valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
            banco_id: 1, usuario_id: usuario_id)
          if pago.save
            query = <<-SQL 
            SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
            SQL
            Facturacion.connection.clear_query_cache
            pago_id = Facturacion.connection.select_all(query)
            pago_id = (pago_id[0]["id"]).to_i
            saldo_ab = valor_fact + iva
            abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
              factura_id: facturacion_id, doc_factura_id: facturacion.documento_id,
              prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id,
              fechabono: f_elaboracion, saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
            unless abono.save
              return respuesta = 2
            end
          else
            return respuesta = 2
          end
        end
        query = <<-SQL 
        SELECT * FROM anticipos WHERE entidad_id = #{entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_tv};
        SQL
        Facturacion.connection.clear_query_cache
        anticipo = Facturacion.connection.select_all(query)
        unless anticipo.blank?
          if anticipo[0]["factura_id"] == nil
            valor_total = facturacion.valor + facturacion.iva
            if anticipo[0]["valor"] >= valor_total
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{facturacion_id}, doc_factura_id = #{facturacion.documento_id}, prefijo = '#{facturacion.prefijo}', nrofact = #{facturacion.nrofact} WHERE id = #{anticipo[0]["id"]};
              UPDATE facturacion set estado_id = #{estado_pag} WHERE id = #{facturacion_id};
              SQL
            else
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{facturacion_id}, doc_factura_id = #{facturacion.documento_id}, prefijo = '#{facturacion.prefijo}', nrofact = #{facturacion.nrofact} WHERE id = #{anticipo[0]["id"]};
              SQL
            end
            Facturacion.connection.select_all(query)
            query = <<-SQL 
            SELECT * FROM VwPagosAnticipados WHERE entidad_id = #{senal.entidad_id};
            SQL
            Facturacion.connection.clear_query_cache
            pago_id = Facturacion.connection.select_all(query)
            query = <<-SQL 
            SELECT * FROM anticipos WHERE nropago = #{pago_id[0]["nropago"]};
            SQL
            Facturacion.connection.clear_query_cache
            ant_pagos = Facturacion.connection.select_all(query)
            ult_ant = ant_pagos.last
            if ult_ant["id"] == anticipo[0]["id"]
              query = <<-SQL 
              UPDATE pagos set estado_id = #{estado_pag} WHERE pago_id = #{anticipo[0]["pago_id"]};
              SQL
              Facturacion.connection.select_all(query)
            end
          end
        end
        return respuesta = 1
      else
        plantilla = PlantillaFact.find_by(entidad_id: entidad_id, concepto_id: concepto_int.id)
        tarifa = plantilla.tarifa.valor
        i = 0
        j = 0
        unless factura.blank?
          factura.each do |row|
            detallefact = DetalleFactura.where(nrofact: row["nrofact"])
            if detallefact[0]["concepto_id"] == concepto_int.id
              fact = 1
              j = i
            end
            i += 1
          end
        end
        if fact != 1
          if ban == 1
            if valor_fact <= tarifa
              ban1 = 1
            end
          else
            ban1 = 1
          end
        else
          valor_f = factura[j]["valor"] + factura[j]["iva"]
          valor_t = valor_f + valor_fact
          if ban == 1
            if valor_t <= tarifa
              ban1 = 1
            end
          else
            ban1 = 1
          end
        end
        if ban1 == 1
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Facturacion.connection.clear_query_cache
          ultimo = Facturacion.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1 
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          dias = (fecha2 - fecha1).to_i + 1
          if dias < 30
            if fecha1.month == 2
              dias = 30
            end
          end
          if iva_int > 0
            valor_sin_iva = valor_fact / (iva_int / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: f_elaboracion,
            fechaven: f_vencimiento, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: estado_pend, observacion: observa, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
            SQL
            Facturacion.connection.clear_query_cache
            facturacion_id = Facturacion.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_int.id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_int, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            unless detallef.save
              return respuesta = 2
            end
          else
            return respuesta = 2
          end
        else
          return respuesta = 4
        end
        query = <<-SQL 
        SELECT * FROM anticipos WHERE entidad_id = #{entidad_id} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and servicio_id = #{serv_int};
        SQL
        Facturacion.connection.clear_query_cache
        anticipo = Facturacion.connection.select_all(query)
        unless anticipo.blank?
          if anticipo[0]["factura_id"] == nil
            valor_total = facturacion.valor + facturacion.iva
            if anticipo[0]["valor"] >= valor_total
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{facturacion_id}, doc_factura_id = #{facturacion.documento_id}, prefijo = '#{facturacion.prefijo}', nrofact = #{facturacion.nrofact} WHERE id = #{anticipo[0]["id"]};
              UPDATE facturacion set estado_id = #{estado_pag} WHERE id = #{facturacion_id};
              SQL
            else
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{facturacion_id}, doc_factura_id = #{facturacion.documento_id}, prefijo = '#{facturacion.prefijo}', nrofact = #{facturacion.nrofact} WHERE id = #{anticipo[0]["id"]};
              SQL
            end
            Facturacion.connection.select_all(query)
            query = <<-SQL 
            SELECT * FROM VwPagosAnticipados WHERE entidad_id = #{senal.entidad_id};
            SQL
            Facturacion.connection.clear_query_cache
            pago_id = Facturacion.connection.select_all(query)
            query = <<-SQL 
            SELECT * FROM anticipos WHERE nropago = #{pago_id[0]["nropago"]};
            SQL
            Facturacion.connection.clear_query_cache
            ant_pagos = Facturacion.connection.select_all(query)
            ult_ant = ant_pagos.last
            if ult_ant["id"] == anticipo[0]["id"]
              query = <<-SQL 
              UPDATE pagos set estado_id = #{estado_pag} WHERE pago_id = #{anticipo[0]["pago_id"]};
              SQL
              Facturacion.connection.select_all(query)
            end
          end
        end
        return respuesta = 1
      end
    else
      return respuesta = 3
    end
  end

  def self.anular_factura(entidad_id, concepto_id, nrodcto)
    resp = 0
    estado_anul = Estado.find_by(abreviatura: 'AN').id
    query = <<-SQL 
    SELECT factura_id FROM detalle_factura WHERE nrofact = #{nrodcto} and concepto_id = #{concepto_id};
    SQL
    Facturacion.connection.clear_query_cache
    factura_id = Facturacion.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM pagos WHERE entidad_id = #{entidad_id} and estado_id <> #{estado_anul};
    SQL
    Facturacion.connection.clear_query_cache
    pagos = Facturacion.connection.select_all(query)
    pagos.each do |p|
      query = <<-SQL 
      SELECT factura_id FROM abonos WHERE pago_id = #{p["id"]};
      SQL
      Facturacion.connection.clear_query_cache
      abonos = Facturacion.connection.select_all(query)
      abonos.each do |a|
        if a["factura_id"] == factura_id[0]["factura_id"]
          resp = 1
        end
      end
    end
    if resp != 1
      query = <<-SQL 
      UPDATE facturacion SET valor = 0, iva = 0, estado_id = #{estado_anul}, observacion = 'ANULADA' WHERE id = #{factura_id[0]["factura_id"]};
      UPDATE detalle_factura SET valor = 0, porcentajeIva = 0, iva = 0, observacion = 'ANULADA' WHERE factura_id = #{factura_id[0]["factura_id"]};
      SQL
      Facturacion.connection.clear_query_cache
      Facturacion.connection.select_all(query)
      return true
    else
      return false
    end
  end

  def self.listado_fras_ventas(f_ini, f_fin)
    facturas = Array.new
    fechaini = Date.parse f_ini.to_s
    fechafin = Date.parse f_fin.to_s
    query = <<-SQL 
    SELECT * FROM facturacion WHERE fechatrn >= '#{fechaini}' and fechatrn <= '#{fechafin}' ORDER BY nrofact;
    SQL
    facturacion = Facturacion.connection.select_all(query)
    entidades = Entidad.all
    i = 0
    facturacion.each do |f|
      entidad = Entidad.find(f["entidad_id"])
      fecha = (f["fechatrn"].to_s).split(' ')
      fecha1 = fecha[0].split('-')
      fecha_time = Time.new(fecha1[0], fecha1[1], fecha1[2])
      f_formato = fecha_time.strftime("%d/%m/%Y")
      if entidad.persona.nombre2.blank?
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      else
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.nombre2 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      end
      facturas[i] = { 'entidad_id' => f["entidad_id"], 'documento' => entidad.persona.documento,
        'nombres' => nombres, 'nrofact' => f["nrofact"],
        'valor' => (f["valor"].to_f).round, 'iva' => (f["iva"].to_f).round, 
        'total' => (f["valor"].to_f).round + (f["iva"].to_f).round, 'fecha' => f_formato,
        'observacion' => f["observacion"] }
      i += 1
    end
    facturas
  end

  def self.impresion_facturacion(zona, tipo_fact, f_elaboracion, f_inicio, f_fin, f_vencimiento, 
    fact_inicial, fact_final, saldo_inicial, saldo_final, corte_serv, nota_1, nota_2, nota_3, rango)
    fecha_ini = Date.parse f_inicio
    f_inicio_dia = fecha_ini.day
    f_inicio_mes = fecha_ini.month
    f_inicio_ano = fecha_ini.year
    query = <<-SQL
    if object_id('VwImpresionFacturacion','v') is not null
    drop view VwImpresionFacturacion;
    SQL
    facturacion = Facturacion.connection.select_all(query)
    query = <<-SQL
    CREATE VIEW [dbo].[VwImpresionFacturacion] AS
    SELECT DISTINCT (fact.id), fact.entidad_id, df.cantidad, df.observacion, df.valor, df.iva, ab.abono as descuento 
    FROM facturacion fact
    LEFT OUTER JOIN detalle_factura df ON fact.id = df.factura_id
    LEFT OUTER JOIN plantilla_fact plantilla ON fact.entidad_id = plantilla.entidad_id
    LEFT OUTER JOIN abonos ab ON fact.id = ab.factura_id and ab.doc_pagos_id = 6
    WHERE fact.nrofact >= #{fact_inicial} and fact.nrofact <= #{fact_final} and plantilla.estado_id = 1 and fact.estado_id <> 8 and fact.documento_id = 1 and month(fact.fechatrn) = #{f_inicio_mes} and year(fact.fechatrn) = #{f_inicio_ano}; 
    SQL
    facturacion = Facturacion.connection.select_all(query)
  end
end