class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :fechatrn, :fechaven, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, observacion, tecnico_id, solicita,
    zonaNue, barrioNue, direccionNue, decos, usuario_id)
    senal = Senal.find_by(entidad_id: entidad_id)
    pref = Resolucion.last.prefijo
    ban = 0
    ban1 = 0
    resp = 0
    estado = 0
    tipo_fact_ant = TipoFacturacion.find_by(nombre: 'ANTICIPADA').id
    tipo_fact_ven = TipoFacturacion.find_by(nombre: 'VENCIDA').id
    estado_aplicado = Estado.find_by(abreviatura: 'AP').id
    estado_pend = Estado.find_by(abreviatura: 'PE').id
    f_fact = fechatrn.split('/')
    f_fact = Time.new(f_fact[2], f_fact[1], f_fact[0])
    nombre_mes = Facturacion.mes(f_fact.strftime("%B"))
    observacion = observacion.upcase! unless observacion == observacion.upcase
    consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados ordenes').valor
    if consecutivos == 'S'
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id = #{concepto_id};
      SQL
    else
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes;
      SQL
    end
    Orden.connection.clear_query_cache
    ultimo = Orden.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo = 1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    case concepto_id
    when "7", "8", "17", "18"
      if concepto_id == "7" || concepto_id == "17"
        concepto_plant = 3
      else
        concepto_plant = 4
      end
      estado = Estado.find_by(abreviatura: 'A').id
    when "15", "16"
      if concepto_id == "15"
        concepto_plant = 3
      else
        concepto_plant = 4
      end
      estado = Estado.find_by(abreviatura: 'C').id
    when "51"
      concepto_plant = 3
      estado = Estado.find_by(abreviatura: 'A').id
    else
      ban = 1
    end
    unless ban == 1
      plantilla = PlantillaFact.find_by(entidad_id: entidad_id, concepto_id: concepto_plant)
      if plantilla.estado_id == estado
        ban = 1
      end
    end
    if ban == 1
      if concepto_id == "51" || concepto_id == "53"
        if concepto_id == "53"
          plantilla_decos = PlantillaFact.find_by(entidad_id: entidad_id, concepto_id: 51)
          if plantilla_decos
            ban1 = 1
          else
            return resp = 4
          end
        else
          ban1 = 1
        end
        if ban1 == 1
          orden = Orden.new(entidad_id: entidad_id, concepto_id: concepto_id, fechatrn: fechatrn, fechaven: fechaven,
            nrorden: ultimo, estado_id: estado_aplicado, observacion: observacion, tecnico_id: tecnico_id, usuario_id: usuario_id)
        end
      else
        orden = Orden.new(entidad_id: entidad_id, concepto_id: concepto_id, fechatrn: fechatrn, fechaven: fechaven,
          nrorden: ultimo, estado_id: estado_pend, observacion: observacion, tecnico_id: tecnico_id, usuario_id: usuario_id)
      end
      if orden.save
        query = <<-SQL 
        SELECT id FROM ordenes WHERE nrorden = #{orden.nrorden} and concepto_id = #{concepto_id};
        SQL
        Orden.connection.clear_query_cache
        orden_id = Orden.connection.select_all(query)
        orden_id = (orden_id[0]["id"]).to_i
        MvtoRorden.create(registro_orden_id: 1, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: fechatrn, usuario_id: usuario_id)
        MvtoRorden.create(registro_orden_id: 2, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: usuario_id, usuario_id: usuario_id)
        MvtoRorden.create(registro_orden_id: 3, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: tecnico_id, usuario_id: usuario_id)
        MvtoRorden.create(registro_orden_id: 11, orden_id: orden_id, concepto_id: orden.concepto_id,
          nrorden: orden.nrorden, valor: solicita, usuario_id: usuario_id)
      else
        return resp = 2
      end
      case concepto_id
      when "5", "6", "9", "10", "15", "16", "19", "20"
        if valor > 0
          doc = 1
          concepto = Concepto.find(concepto_id)
          observa = concepto.nombre
          iva_concepto = concepto.porcentajeIva
          if iva_concepto > 0
            valor_sin_iva = valor / (iva_concepto / 100 + 1)
            iva = valor - valor_sin_iva
            valor = valor_sin_iva
          end
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Orden.connection.clear_query_cache
          ultimo = Orden.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fechaven,
            fechaven: fechaven, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
            estado_id: estado_pend, observacion: observa, reporta: '0', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            facturacion_id = Orden.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
              factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
                nrorden: orden.nrorden, usuario_id: usuario_id)
              if factura_orden.save
                return resp = 1
              else
                return resp = 2
              end
            else
              return resp = 2
            end
          else
            return resp = 2
          end
        else
          return resp = 1
        end
      when "13", "14"
        if valor > 0
          doc = 1
          concepto = Concepto.find(concepto_id)
          observa = concepto.nombre
          iva_concepto = concepto.porcentajeIva
          if iva_concepto > 0
            valor_sin_iva = valor / (iva_concepto / 100 + 1)
            iva = valor - valor_sin_iva
            valor = valor_sin_iva
          end
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
          SQL
          Orden.connection.clear_query_cache
          ultimo = Orden.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fechaven,
            fechaven: fechaven, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
            estado_id: estado_pend, observacion: observa, reporta: '0', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            facturacion_id = Orden.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
              fact_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
                nrorden: orden.nrorden, usuario_id: usuario_id)
              if fact_orden.save
                traslado = Traslado.new(orden_id: orden_id, concepto_id: concepto_id, nrorden: orden.nrorden, zonaAnt_id: senal.zona_id,
                  barrioAnt_id: senal.barrio_id, direccionAnt: senal.direccion, zonaNue_id: zonaNue, barrioNue_id: barrioNue,
                  direccionNue: direccionNue, usuario_id: usuario_id)
                if traslado.save
                  return resp = 1
                else
                  return resp = 2
                end
              else
                return resp = 2
              end
            else
              return resp = 2
            end
          else
            return resp = 2
          end
        else
          return resp = 1
        end
      when "51"
        tarifa_id = 0
        estado_activo = Estado.find_by(abreviatura: 'A').id
        estado_ord = Estado.find_by(abreviatura: 'AP').id
        plan_tv = Plan.find_by(nombre: 'TELEVISION').id
        query = <<-SQL 
        UPDATE ordenes set estado_id = #{estado_ord} WHERE id = #{orden_id};
        SQL
        Orden.connection.select_all(query)
        tarifa_decos = Tarifa.where("zona_id = #{senal.zona_id} and concepto_id = #{concepto_id} and plan_id = #{plan_tv}")
        tarifa_decos.each do |tarifa|
          if tarifa_decos.valor == valor
            tarifa_id = tarifa_decos.id
          end
        end
        if tarifa_id == 0
          tarifa = Tarifa.new(zona_id: senal.zona_id, concepto_id: concepto_id, plan_id: plan_tv, valor: valor, 
            estado_id: estado_activo, usuario_id: usuario_id)
          if tarifa.save
            tarifa_id = tarifa.id
          else
            return resp = 2
          end
        end
        plantilla = PlantillaFact.new(entidad_id: entidad_id, concepto_id: concepto_id, estado_id: estado_activo, 
          tarifa_id: tarifa_id, fechaini: fechatrn, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: usuario_id)
        if senal.update(decos: decos)
          return resp = 1
        else
          return resp = 2
        end
      when "53"
        if plantilla_decos.destroy()
          return resp = 1
        else
          return resp = 2
        end
      else
        return resp = 1
      end
    else
      return resp = 3
    end
  end

  def self.editar_orden(orden, fechaven, solicita, tecnico_id, observacion, detalle, solucion, respuesta, usuario_id)
    t = Time.now
    byebug
    senal = Senal.find_by(entidad_id: orden[0]["entidad_id"])
    concepto_fact = 0
    fecha = Date.parse fechaven
    mes = fecha.month
    ano = fecha.year
    fechaini = '01/#{mes}/#{ano}'
    fechaini = Date.parse fechaini
    fechafin = '30/#{mes}/#{ano}'
    fechafin = Date.parse fechafin
    pref = Resolucion.last.prefijo
    estado_ord = Estado.find_by(abreviatura: 'AP').id
    estado_corte = Estado.find_by(abreviatura: 'C').id
    estado_act = Estado.find_by(abreviatura: 'A').id
    estado_pag = Estado.find_by(abreviatura: 'PA').id
    estado_pend = Estado.find_by(abreviatura: 'PE').id
    f_fact = fechaven.split('/')
    f_fact = Time.new(f_fact[2], f_fact[1], f_fact[0])
    nombre_mes = Facturacion.mes(f_fact.strftime("%B"))
    tipo_fact_ant = TipoFacturacion.find_by(nombre: 'ANTICIPADA').id
    tipo_fact_ven = TipoFacturacion.find_by(nombre: 'VENCIDA').id
    observacion = observacion.upcase! unless observacion == observacion.upcase
    solicita = solicita.upcase! unless solicita == solicita.upcase
    solucion = solucion.upcase! unless solucion == solucion.upcase
    MvtoRorden.create(registro_orden_id: 4, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
      nrorden: orden[0]["nrorden"], valor: fechaven, usuario_id: usuario_id)
    MvtoRorden.create(registro_orden_id: 5, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
      nrorden: orden[0]["nrorden"], valor: tecnico_id, usuario_id: usuario_id)
    MvtoRorden.create(registro_orden_id: 6, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
      nrorden: orden[0]["nrorden"], valor: usuario_id, usuario_id: usuario_id)
    MvtoRorden.create(registro_orden_id: 7, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
      nrorden: orden[0]["nrorden"], valor: solucion, usuario_id: usuario_id)
    MvtoRorden.create(registro_orden_id: 11, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
      nrorden: orden[0]["nrorden"], valor: solicita, usuario_id: usuario_id)
    fecha_ven = Date.parse fechaven
    fecha_t = Date.parse t.to_s
    query = <<-SQL 
    UPDATE ordenes set fechaven = '#{fecha_ven.to_s}', estado_id = #{estado_ord}, tecnico_id = #{tecnico_id}, observacion = '#{observacion}', fechacam = '#{fecha_t}' WHERE id = #{orden[0]["id"]};
    SQL
    Orden.connection.select_all(query)
    detalle.each do |d|
      detalle_orden = DetalleOrden.new(orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"], nrorden: orden[0]["nrorden"],
        articulo_id: d["articulo_id"], cantidad: d["cantidad"], valor: d["valor"], porcentajeIva: d["porcentajeIva"],
        iva: d["iva"], costo: d["total"], observacion: observacion, usuario_id: usuario_id)
      unless detalle_orden.save
        return false
      end
    end
    case orden[0]["concepto_id"]
    when 7, 8
      byebug
      facturacion = ''
      ban = 0
      pregunta = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar corte').valor
      if pregunta == 'S'
        if respuesta == 'S'
          ban = 1
        end
      else
        cobro = Parametro.find_by(descripcion: 'Cobra dias al editar corte').valor
        if cobro == 'S'
          ban = 1
        end
      end
      doc = 1
      if orden[0]["concepto_id"] == 7
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id <> 4")
      else
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id = 4")
      end
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ven
          plantillas.each do |plantilla|
            byebug
            ban = 0
            tarifa = plantilla.tarifa.valor
            concepto = Concepto.find(plantilla.concepto_id)
            iva = concepto.porcentajeIva
            observacion_d = concepto.nombre
            if concepto.id == 3
              observacion_d = 'TELEVISION'
            else
              observacion_d = 'INTERNET'
            end
            query = <<-SQL 
            SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            factura = Orden.connection.select_all(query)
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
              dias = (fecha - fechaini).to_i + 1
              if dias < 30
                if fecha.month == 2
                  valor_mens = tarifa
                else
                  valor_dia = tarifa / 30
                  valor_mens = valor_dia * dias
                end
              end
              if iva > 0
                valor_sin_iva = valor_mens / (iva / 100 + 1)
                iva_fact = valor_mens - valor_sin_iva
                valor_mens = valor_sin_iva
              end
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
              SQL
              Orden.connection.clear_query_cache
              ultimo = Orden.connection.select_all(query)
              if ultimo[0]["ultimo"] == nil
                ultimo = 1
              else
                ultimo = (ultimo[0]["ultimo"]).to_i + 1
              end
              if facturacion.blank?
                facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
                  fechaven: fecha.to_s, valor: valor_mens, iva: iva_fact, dias: dias, prefijo: pref, nrofact: ultimo,
                  estado_id: estado_pend, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
                if facturacion.save
                  query = <<-SQL 
                  SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                  SQL
                  Orden.connection.clear_query_cache
                  facturacion_id = Orden.connection.select_all(query)
                  facturacion_id = (facturacion_id[0]["id"]).to_i
                  factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
                    nrorden: orden[0]["nrorden"], usuario_id: usuario_id)
                  unless factura_orden.save
                    return false
                  end
                else
                  return false
                end
              else
                query = <<-SQL 
                UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva_fact} WHERE id = #{facturacion_id};
                SQL
                Orden.connection.select_all(query)
              end
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                valor: valor_mens, porcentajeIva: iva, iva: iva_fact, observacion: observacion_d + ' ' + nombre_mes,
                operacion: '+', usuario_id: usuario_id)
              unless detallef.save
                return false
              end
              if concepto.id == 3
                if senal.entidad.persona.condicionfisica == 'D'
                  valor_total_fact = valor_mens + iva
                  porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                  descuento = valor_total_fact * (porcentaje.to_f / 100)
                  doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                  query = <<-SQL 
                  SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                  SQL
                  Orden.connection.clear_query_cache
                  ultimo = Orden.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: fecha.to_s,
                    valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                    banco_id: 1, usuario_id: usuario_id)
                  if pago.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                    SQL
                    Orden.connection.clear_query_cache
                    pago_id = Orden.connection.select_all(query)
                    pago_id = (pago_id[0]["id"]).to_i
                    saldo_ab = facturacion.valor + facturacion.iva
                    abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                      factura_id: facturacion_id, doc_factura_id: facturacion.documento_id, prefijo: facturacion.prefijo, 
                      nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id, fechabono: fecha.to_s, 
                      saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                    unless abono.save
                      return false
                    end
                  else
                    return false
                  end
                end
              end
            else
              fecha3 = Date.parse factura[i]["fechaven"].to_s
              dias_fact = (fecha - fecha3).to_i
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
              end
            end
          end
        end
      end
      plantillas.each do |plantilla|
        unless plantilla.update(estado_id: estado_corte)
          return false
        end
      end
      return true
    when 11, 12
      byebug
      ban = 0
      pregunta = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar instalacion').valor
      if pregunta == 'S'
        if respuesta == 'S'
          ban = 1
        end
      else
        cobro = Parametro.find_by(descripcion: 'Cobra dias al editar instalacion').valor
        if cobro == 'S'
          ban = 1
        end
      end
      doc = 1
      if orden[0]["concepto_id"] == 11
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id <> 4")
      else
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id = 4")
      end
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ant
          plantillas.each do |plantilla|
            byebug
            ban = 0
            tarifa = plantilla.tarifa.valor
            concepto = Concepto.find(plantilla.concepto_id)
            iva = concepto.porcentajeIva
            observacion_d = concepto.nombre
            if concepto.id == 3
              observacion_d = 'TELEVISION'
            else
              observacion_d = 'INTERNET'
            end
            query = <<-SQL 
            SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            factura = Orden.connection.select_all(query)
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
              dias = (fecha - fechaini).to_i + 1
              if dias < 30
                if fecha.month == 2
                  valor_mens = tarifa
                else
                  valor_dia = tarifa / 30
                  valor_mens = valor_dia * dias
                end
              end
              if iva > 0
                valor_sin_iva = valor_mens / (iva / 100 + 1)
                iva_fact = valor_mens - valor_sin_iva
                valor_mens = valor_sin_iva
              end
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
              SQL
              Orden.connection.clear_query_cache
              ultimo = Orden.connection.select_all(query)
              if ultimo[0]["ultimo"] == nil
                ultimo = 1
              else
                ultimo = (ultimo[0]["ultimo"]).to_i + 1
              end
              if facturacion.blank?
                facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
                  fechaven: fecha.to_s, valor: valor_mens, iva: iva_fact, dias: dias, prefijo: pref, nrofact: ultimo,
                  estado_id: estado_pend, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
                if facturacion.save
                  query = <<-SQL 
                  SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                  SQL
                  Orden.connection.clear_query_cache
                  facturacion_id = Orden.connection.select_all(query)
                  facturacion_id = (facturacion_id[0]["id"]).to_i
                  factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
                    nrorden: orden[0]["nrorden"], usuario_id: usuario_id)
                  unless factura_orden.save
                    return false
                  end
                else
                  return false
                end
              else
                query = <<-SQL 
                UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva_fact} WHERE id = #{facturacion_id};
                SQL
                Orden.connection.select_all(query)
              end
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                valor: valor_mens, porcentajeIva: iva, iva: iva_fact, observacion: observacion_d + ' ' + nombre_mes,
                operacion: '+', usuario_id: usuario_id)
              unless detallef.save
                return false
              end
              if concepto.id == 3
                if senal.entidad.persona.condicionfisica == 'D'
                  valor_total_fact = valor_mens + iva
                  porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                  descuento = valor_total_fact * (porcentaje.to_f / 100)
                  doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                  query = <<-SQL 
                  SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                  SQL
                  Orden.connection.clear_query_cache
                  ultimo = Orden.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: fecha.to_s,
                    valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                    banco_id: 1, usuario_id: usuario_id)
                  if pago.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                    SQL
                    Orden.connection.clear_query_cache
                    pago_id = Orden.connection.select_all(query)
                    pago_id = (pago_id[0]["id"]).to_i
                    saldo_ab = facturacion.valor + facturacion.iva
                    abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                      factura_id: facturacion_id, doc_factura_id: facturacion.documento_id, prefijo: facturacion.prefijo, 
                      nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id, fechabono: fecha.to_s, 
                      saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                    unless abono.save
                      return false
                    end
                  else
                    return false
                  end
                end
              end
            else
              fecha3 = Date.parse factura[i]["fechaven"].to_s
              dias_fact = (fecha - fecha3).to_i
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
              end
            end
          end
        end
      end
      plantillas.each do |plantilla|
        unless plantilla.update(estado_id: estado_corte)
          return false
        end
      end
      return true
    when 13, 14
      traslado = Traslado.find_by(orden_id: orden[0]["id"])
      if senal.update(direccion: traslado.direccionNue, zona_id: traslado.zonaNue_id, barrio_id: traslado.barrioNue_id)
        return true
      else
        return false
      end
    when 15, 16
      byebug
      ban = 0
      pregunta = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar reconexion').valor
      if pregunta == 'S'
        if respuesta == 'S'
          ban = 1
        end
      else
        cobro = Parametro.find_by(descripcion: 'Cobra dias al editar reconexion').valor
        if cobro == 'S'
          ban = 1
        end
      end
      if ban == 1
        genera_fact = Parametro.find_by(descripcion: 'Genera factura en reconexion').valor
        if genera_fact != 'S'
          ban = 0
        end
      end
      doc = 1
      if orden[0]["concepto_id"] == 15
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id <> 4")
      else
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id = 4")
      end
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ant
          plantillas.each do |plantilla|
            byebug
            ban = 0
            tarifa = plantilla.tarifa.valor
            concepto = Concepto.find(plantilla.concepto_id)
            iva = concepto.porcentajeIva
            observacion_d = concepto.nombre
            if concepto.id == 3
              observacion_d = 'TELEVISION'
            else
              observacion_d = 'INTERNET'
            end
            query = <<-SQL 
            SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            factura = Orden.connection.select_all(query)
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
              dias = (fecha - fechaini).to_i + 1
              if dias < 30
                if fecha.month == 2
                  valor_mens = tarifa
                else
                  valor_dia = tarifa / 30
                  valor_mens = valor_dia * dias
                end
              end
              if iva > 0
                valor_sin_iva = valor_mens / (iva / 100 + 1)
                iva_fact = valor_mens - valor_sin_iva
                valor_mens = valor_sin_iva
              end
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
              SQL
              Orden.connection.clear_query_cache
              ultimo = Orden.connection.select_all(query)
              if ultimo[0]["ultimo"] == nil
                ultimo = 1
              else
                ultimo = (ultimo[0]["ultimo"]).to_i + 1
              end
              if facturacion.blank?
                facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
                  fechaven: fecha.to_s, valor: valor_mens, iva: iva_fact, dias: dias, prefijo: pref, nrofact: ultimo,
                  estado_id: estado_pend, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
                if facturacion.save
                  query = <<-SQL 
                  SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                  SQL
                  Orden.connection.clear_query_cache
                  facturacion_id = Orden.connection.select_all(query)
                  facturacion_id = (facturacion_id[0]["id"]).to_i
                  factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
                    nrorden: orden[0]["nrorden"], usuario_id: usuario_id)
                  unless factura_orden.save
                    return false
                  end
                else
                  return false
                end
              else
                query = <<-SQL 
                UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva_fact} WHERE id = #{facturacion_id};
                SQL
                Orden.connection.select_all(query)
              end
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                valor: valor_mens, porcentajeIva: iva, iva: iva_fact, observacion: observacion_d + ' ' + nombre_mes,
                operacion: '+', usuario_id: usuario_id)
              unless detallef.save
                return false
              end
              if concepto.id == 3
                if senal.entidad.persona.condicionfisica == 'D'
                  valor_total_fact = valor_mens + iva
                  porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                  descuento = valor_total_fact * (porcentaje.to_f / 100)
                  doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                  query = <<-SQL 
                  SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                  SQL
                  Orden.connection.clear_query_cache
                  ultimo = Orden.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: fecha.to_s,
                    valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                    banco_id: 1, usuario_id: usuario_id)
                  if pago.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                    SQL
                    Orden.connection.clear_query_cache
                    pago_id = Orden.connection.select_all(query)
                    pago_id = (pago_id[0]["id"]).to_i
                    saldo_ab = facturacion.valor + facturacion.iva
                    abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                      factura_id: facturacion_id, doc_factura_id: facturacion.documento_id, prefijo: facturacion.prefijo, 
                      nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id, fechabono: fecha.to_s, 
                      saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                    unless abono.save
                      return false
                    end
                  else
                    return false
                  end
                end
              end
            else
              fecha3 = Date.parse factura[i]["fechaven"].to_s
              dias_fact = (fecha - fecha3).to_i
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
              end
            end
          end
        end
      end
      plantillas.each do |plantilla|
        unless plantilla.update(estado_id: estado_corte)
          return false
        end
      end
      return true
    when 17, 18
      pagado = false
      fact_vent_id = 0
      fact_vent_valor = 0
      fact_vent_iva = 0
      fact_vent_documento_id = 0
      fact_vent_prefijo = 0
      fact_vent_nrofact = 0
      fecha_fact = Date.parse fechaven
      mes = fecha_fact.month
      ano = fecha_fact.year
      estado = Estado.find_by(abreviatura: 'R').id
      pregunta = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar retiro').valor
      if pregunta == 'S'
        if respuesta == 'S'
          ban = 1
        end
      else
        cobro = Parametro.find_by(descripcion: 'Cobra dias al editar retiro').valor
        if cobro == 'S'
          ban = 1
        end
      end
      doc = 1
      if orden[0]["concepto_id"] == 17
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id <> 4")
      else
        plantillas = PlantillaFact.where("entidad_id = #{orden[0]["entidad_id"]} and concepto_id = 4")
      end
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ven
          plantillas.each do |plantilla|
            byebug
            ban = 0
            tarifa = plantilla.tarifa.valor
            concepto = Concepto.find(plantilla.concepto_id)
            iva = concepto.porcentajeIva
            observacion_d = concepto.nombre
            if concepto.id == 3
              observacion_d = 'TELEVISION'
            else
              observacion_d = 'INTERNET'
            end
            query = <<-SQL 
            SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and year(fechatrn) = #{ano} and month(fechatrn) = #{mes} and documento_id = #{doc};
            SQL
            Orden.connection.clear_query_cache
            factura = Orden.connection.select_all(query)
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
              dias = (fecha - fechaini).to_i + 1
              if dias < 30
                if fecha.month == 2
                  valor_mens = tarifa
                else
                  valor_dia = tarifa / 30
                  valor_mens = valor_dia * dias
                end
              end
              if iva > 0
                valor_sin_iva = valor_mens / (iva / 100 + 1)
                iva_fact = valor_mens - valor_sin_iva
                valor_mens = valor_sin_iva
              end
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{doc};
              SQL
              Orden.connection.clear_query_cache
              ultimo = Orden.connection.select_all(query)
              if ultimo[0]["ultimo"] == nil
                ultimo = 1
              else
                ultimo = (ultimo[0]["ultimo"]).to_i + 1
              end
              if facturacion.blank?
                facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
                  fechaven: fecha.to_s, valor: valor_mens, iva: iva_fact, dias: dias, prefijo: pref, nrofact: ultimo,
                  estado_id: estado_pend, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
                if facturacion.save
                  query = <<-SQL 
                  SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{doc};
                  SQL
                  Orden.connection.clear_query_cache
                  facturacion_id = Orden.connection.select_all(query)
                  facturacion_id = (facturacion_id[0]["id"]).to_i
                  factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
                    nrorden: orden[0]["nrorden"], usuario_id: usuario_id)
                  unless factura_orden.save
                    return false
                  end
                  fact_vent_id = facturacion_id
                  fact_vent_valor = facturacion.valor
                  fact_vent_iva = facturacion.iva
                  fact_vent_documento_id = facturacion.documento_id
                  fact_vent_prefijo = facturacion.prefijo
                  fact_vent_nrofact = facturacion.nrofact
                else
                  return false
                end
              else
                query = <<-SQL 
                UPDATE facturacion set valor = valor + #{valor_mens}, iva = iva + #{iva_fact} WHERE id = #{facturacion_id};
                SQL
                Orden.connection.select_all(query)
                fact_vent_valor += valor_mens
                fact_vent_iva += iva_fact
              end
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
                valor: valor_mens, porcentajeIva: iva, iva: iva_fact, observacion: observacion_d + ' ' + nombre_mes,
                operacion: '+', usuario_id: usuario_id)
              unless detallef.save
                return false
              end
              if concepto.id == 3
                if senal.entidad.persona.condicionfisica == 'D'
                  valor_total_fact = valor_mens + iva
                  porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                  descuento = valor_total_fact * (porcentaje.to_f / 100)
                  doc_pago = Documento.find_by(nombre: 'DESCUENTOS').id
                  query = <<-SQL 
                  SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_pago};
                  SQL
                  Orden.connection.clear_query_cache
                  ultimo = Orden.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  pago = Pago.new(entidad_id: senal.entidad_id, documento_id: doc_pago, nropago: ultimo, fechatrn: fecha.to_s,
                    valor: descuento, estado_id: estado_pag, observacion: 'DESCUENTO DISCAPACITADOS', forma_pago_id: 1,
                    banco_id: 1, usuario_id: usuario_id)
                  if pago.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{doc_pago};
                    SQL
                    Orden.connection.clear_query_cache
                    pago_id = Orden.connection.select_all(query)
                    pago_id = (pago_id[0]["id"]).to_i
                    saldo_ab = facturacion.valor + facturacion.iva
                    abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                      factura_id: facturacion_id, doc_factura_id: facturacion.documento_id, prefijo: facturacion.prefijo, 
                      nrofact: facturacion.nrofact, concepto_id: detallef.concepto_id, fechabono: fecha.to_s, 
                      saldo: saldo_ab, abono: pago.valor, usuario_id: pago.usuario_id)
                    unless abono.save
                      return false
                    end
                  else
                    return false
                  end
                end
              end
            else
              fecha3 = Date.parse factura[i]["fechaven"].to_s
              dias_fact = (fecha - fecha3).to_i
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
      plantillas.each do |plantilla|
        unless plantilla.update(estado_id: estado_corte)
          return false
        end
      end
      return true
    end
  end

  def self.anular_orden(orden)
    resp = 0
    ban = 0
    byebug
    estado_anular = Estado.find_by(abreviatura: 'AN').id
    estado = Estado.find_by(abreviatura: 'AP').id
    if orden[0]["estado_id"] == estado
      return resp = 3
    else
      factura_ord = FacturaOrden.find_by(orden_id: orden[0]["id"])
      if factura_ord.blank?
        ban = 2
      else
        query = <<-SQL 
        SELECT id FROM pagos WHERE entidad_id = #{orden[0]["entidad_id"]};
        SQL
        Orden.connection.clear_query_cache
        pagos = Orden.connection.select_all(query)
        pagos.each do |p|
          abonos = Abono.where(pago_id: p["id"])
          abonos.each do |a|
            if a.factura_id == factura_ord.factura_id
              ban = 1
            end
          end
        end
      end
      case orden[0]["concepto_id"]
      when 5, 6, 9, 10, 19, 20
        if ban == 1
          return resp = 4
        elsif ban == 2
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          SQL
        else
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          UPDATE facturacion set valor = 0, iva = 0, estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{factura_ord.factura_id};
          UPDATE detalle_factura set valor = 0, porcentajeIva = 0, iva = 0, observacion = 'ANULADA' WHERE factura_id = #{factura_ord.factura_id};
          SQL
        end
        Orden.connection.select_all(query)
        return resp = 1
      when 7, 8
        query = <<-SQL 
        UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
        SQL
        Orden.connection.select_all(query)
        return resp = 1
      when 11, 12
        estado = Estado.find_by(abreviatura: 'N').id
        query = <<-SQL 
        UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
        SQL
        Orden.connection.select_all(query)
        if orden[0]["concepto_id"] == 11
          concepto_plant = 3
        else
          concepto_plant = 4
        end
        plantilla = PlantillaFact.find_by(entidad_id: orden[0]["entidad_id"], concepto_id: concepto_plant)
        if plantilla.update(estado_id: estado)
          return resp = 1
        else
          return resp = 2
        end
      when 13, 14
        if ban == 1
          return resp = 4
        elsif ban == 2
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          SQL
        else
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          UPDATE facturacion set valor = 0, iva = 0, estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{factura_ord.factura_id};
          UPDATE detalle_factura set valor = 0, porcentajeIva = 0, iva = 0, observacion = 'ANULADA' WHERE factura_id = #{factura_ord.factura_id};
          SQL
        end
        Orden.connection.select_all(query)
        traslado = Traslado.find_by(orden_id: orden[0]["id"])
        if traslado.update(direccionNue: 'ANULADA')
          return resp = 1
        else
          return resp = 2
        end
      when 15, 16
        if ban == 1
          return resp = 2
        elsif ban == 2
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          SQL
        else
          query = <<-SQL 
          UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
          UPDATE facturacion set valor = 0, iva = 0, estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{factura_ord.factura_id};
          UPDATE detalle_factura set valor = 0, porcentajeIva = 0, iva = 0, observacion = 'ANULADA' WHERE factura_id = #{factura_ord.factura_id};
          SQL
        end
        Orden.connection.select_all(query)
        return resp = 1
      when 17, 18
        query = <<-SQL 
        UPDATE ordenes set estado_id = #{estado_anular}, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
        SQL
        Orden.connection.select_all(query)
        return resp = 1
      when 51
        return resp = 5
      end
    end
  end

  def self.listado_ordenes(f_ini, f_fin)
    ordenes_array = Array.new
    f_creacion = ''
    u_creacion = ''
    tec_asigando = ''
    f_ejecucion = ''
    tec_ejecucion = ''
    u_cierra = ''
    solucion = ''
    f_anulacion = ''
    u_anula = ''
    motivo_anl = ''
    solicitado = ''
    valor = 0
    fechaini = Date.parse f_ini.to_s
    fechafin = Date.parse f_fin.to_s
    query = <<-SQL 
    SELECT * FROM ordenes WHERE fechatrn >= '#{fechaini}' and fechatrn <= '#{fechafin}' ORDER BY nrorden;
    SQL
    ordenes = Facturacion.connection.select_all(query)
    entidades = Entidad.all
    i = 0
    ordenes.each do |o|
      entidad = Entidad.find(o["entidad_id"])
      fecha = (o["fechatrn"].to_s).split(' ')
      fecha1 = fecha[0].split('-')
      fecha_time = Time.new(fecha1[0], fecha1[1], fecha1[2])
      f_formato = fecha_time.strftime("%d/%m/%Y")
      concepto = Concepto.find(o["concepto_id"])
      concepto_cod = concepto.codigo
      concepto_nom = concepto.nombre
      if entidad.persona.nombre2.blank?
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      else
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.nombre2 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      end
      zona = Zona.find(entidad.senales[0]["zona_id"]).nombre
      barrio = Barrio.find(entidad.senales[0]["barrio_id"]).nombre
      fact_orden = FacturaOrden.find_by(orden_id: o["id"])
      estado = Estado.find(o["estado_id"]).nombre
      mvto_orden = MvtoRorden.where(orden_id: o["id"])
      mvto_orden.each do |m|
        case m["registro_orden_id"]
        when 1
          f_creacion = m["valor"]
        when 2
          u_creacion_id = m["valor"]
          u_creacion = Usuario.find(u_creacion_id).nombre 
        when 3
          tec_asigando_id = m["valor"]
          tec_ent = Entidad.find(tec_asigando_id)
          if tec_ent.persona.nombre2.blank?
            tec_asigando = tec_ent.persona.nombre1 + ' ' + tec_ent.persona.apellido1 + ' ' + tec_ent.persona.apellido2
          else
            tec_asigando = tec_ent.persona.nombre1 + ' ' + tec_ent.persona.nombre2 + ' ' + tec_ent.persona.apellido1 + ' ' + tec_ent.persona.apellido2
          end
        when 4
          f_ejecucion = m["valor"]
        when 5
          tec_ejecucion_id = m["valor"]
          tec_ent_ejec = Entidad.find(tec_ejecucion_id)
          if tec_ent_ejec.persona.nombre2.blank?
            tec_ejecucion = tec_ent_ejec.persona.nombre1 + ' ' + tec_ent_ejec.persona.apellido1 + ' ' + tec_ent_ejec.persona.apellido2
          else
            tec_ejecucion = tec_ent_ejec.persona.nombre1 + ' ' + tec_ent_ejec.persona.nombre2 + ' ' + tec_ent_ejec.persona.apellido1 + ' ' + tec_ent_ejec.persona.apellido2
          end
        when 6
          u_cierra_id = m["valor"]
          u_cierra = Usuario.find(u_cierra_id).login
        when 7
          solucion = m["valor"]
        when 8
          f_anulacion = m["valor"]
        when 9
          u_anula_id = m["valor"]
          u_anula = Usuario.find(u_anula_id).login
        when 10
          motivo_anl = m["valor"]
        when 11
          solicitado = m["valor"]
        end
      end
      unless fact_orden.blank?
        query = <<-SQL 
        SELECT valor, iva FROM facturacion WHERE id = #{fact_orden["factura_id"]};
        SQL
        Orden.connection.clear_query_cache
        factura = Orden.connection.select_all(query)
        valor = (factura[0]["valor"].to_f).round + (factura[0]["iva"].to_f).round
      end
      ordenes_array[i] = { 'cpto_cod' => concepto_cod, 'cpto_nombre' => concepto_nom,
        'entidad_id' => o["entidad_id"], 'nombres' => nombres, 'direccion' => entidad.senales[0]["direccion"],
        'zona' => zona, 'barrio' => barrio, 'nrorden' => o["nrorden"],
        'valor' => valor, 'observacion' => o["observacion"], 'estado' => estado, 
        'fechacreacion' => f_creacion, 'usuariocreacion' => u_creacion, 
        'tecnico_asignado' => tec_asigando, 'fechaejec' => f_ejecucion,'tecnico_ejec' => tec_ejecucion, 
        'usuariocierra' => u_cierra, 'solucion' => solucion, 'fecha_anul' => f_anulacion, 
        'usuarioanula' => u_anula, 'solicitado' => solicitado }
      i += 1
    end
    ordenes_array
  end
end
