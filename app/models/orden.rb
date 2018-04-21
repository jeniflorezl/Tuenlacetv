class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :fechatrn, :fechaven, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, observacion, tecnico_id, 
    zonaNue, barrioNue, direccionNue, usuario_id)
    senal = Senal.find_by(entidad_id: entidad_id)
    pref = Resolucion.last.prefijo
    ban = 0
    resp = 0
    estado = 0
    tipo_fact_ant = TipoFacturacion.find_by(nombre: 'ANTICIPADA').id
    tipo_fact_ven = TipoFacturacion.find_by(nombre: 'VENCIDA').id
    f_fact = fechatrn.split('/')
    f_fact = Time.new(f_fact[2], f_fact[1], f_fact[0])
    nombre_mes = Facturacion.mes(f_fact.strftime("%B"))
    observacion = observacion.upcase! unless observacion == observacion.upcase
    consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
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
      orden = Orden.new(entidad_id: entidad_id, concepto_id: concepto_id, fechatrn: fechatrn, fechaven: fechaven,
        nrorden: ultimo, estado_id: 6, observacion: observacion, tecnico_id: tecnico_id, usuario_id: usuario_id)
      if orden.save
        query = <<-SQL 
        SELECT id FROM ordenes WHERE nrorden = #{orden.nrorden};
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
      else
        return resp = 2
      end
      case concepto_id
      when "5", "6", "9", "10", "15", "16", "19", "20"
        if valor > 0
          if concepto_id == "5" || concepto_id == "9" || concepto_id == "15" || concepto_id == "19"
            doc = 1
          else
            doc = 2
          end
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
            estado_id: 6, observacion: observa, reporta: '0', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
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
          if concepto_id == "13"
            doc = 1
          else
            doc = 2
          end
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
            estado_id: 6, observacion: observa, reporta: '0', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
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
      else
        return resp = 1
      end
    else
      return resp = 3
    end
  end

  def self.editar_orden(orden, fechaven, solicita, tecnico_id, observacion, detalle, solucion, respuesta, usuario_id)
    t = Time.now
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
    estado = Estado.find_by(abreviatura: 'AP').id
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
    UPDATE ordenes set fechaven = '#{fecha_ven.to_s}', estado_id = #{estado}, tecnico_id = #{tecnico_id}, observacion = '#{observacion}', fechacam = '#{fecha_t}' WHERE id = #{orden[0]["id"]};
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
      ban = 0
      estado = Estado.find_by(abreviatura: 'C').id
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
      if orden[0]["concepto_id"] == 7
        doc = 1
        concepto_fact = 3
        observa_d = 'TELEVISION'
      else
        doc = 2
        concepto_fact = 4
        observa_d = 'INTERNET'
      end
      plantilla = PlantillaFact.find_by(entidad_id: orden[0]["entidad_id"], concepto_id: concepto_fact)
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ven
          dias = (fecha - fechaini).to_i + 1
          valor_concepto = plantilla.tarifa.valor
          valor_dia = valor_concepto / 30
          valor_fact = valor_dia * dias
          iva_concepto = Concepto.find(concepto_fact).porcentajeIva
          if iva_concepto > 0
            valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
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
          facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
            fechaven: fecha.to_s, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
            SQL
            Orden.connection.clear_query_cache
            facturacion_id = Orden.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_fact, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
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
            return false
          end
        end
      end
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    when 11, 12
      ban = 0
      estado = Estado.find_by(abreviatura: 'A').id
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
      if orden[0]["concepto_id"] == 11
        doc = 1
        concepto_fact = 3
        observa_d = 'TELEVISION'
      else
        doc = 2
        concepto_fact = 4
        observa_d = 'INTERNET'
      end
      plantilla = PlantillaFact.find_by(entidad_id: orden[0]["entidad_id"], concepto_id: concepto_fact)
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ant
          dias = (fecha - fechaini).to_i + 1
          valor_concepto = plantilla.tarifa.valor
          valor_dia = valor_concepto / 30
          valor_fact = valor_dia * dias
          iva_concepto = Concepto.find(concepto_fact).porcentajeIva
          if iva_concepto > 0
            valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
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
          facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
            fechaven: fecha.to_s, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
            SQL
            Orden.connection.clear_query_cache
            facturacion_id = Orden.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_fact, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
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
            return false
          end
        end
      end
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    when 13, 14
      traslado = Traslado.find_by(orden_id: orden[0]["id"])
      if senal.update(direccion: traslado.direccionNue, zona_id: traslado.zonaNue_id, barrio_id: traslado.barrioNue_id)
        return true
      else
        return false
      end
    when 15, 16
      ban = 0
      estado = Estado.find_by(abreviatura: 'A').id
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
      if orden[0]["concepto_id"] == 15
        doc = 1
        concepto_fact = 3
        observa_d = 'TELEVISION'
      else
        doc = 2
        concepto_fact = 4
        observa_d = 'INTERNET'
      end
      plantilla = PlantillaFact.find_by(entidad_id: orden[0]["entidad_id"], concepto_id: concepto_fact)
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ant
          query = <<-SQL 
          SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and (SELECT DATEPART(year, fechatrn)) = #{ano} and (SELECT DATEPART(month, fechatrn)) = #{mes};
          SQL
          Facturacion.connection.clear_query_cache
          factura = Facturacion.connection.select_all(query)
          i = 0
          j = 0
          fact_tv = 0
          detallefact = ''
          unless factura.blank?
            factura.each do |row|
              detallefact = DetalleFactura.where(nrofact: row["nrofact"])
              if (detallefact[0]["concepto_id"] == concepto_fact) 
                fact_tv = 1
                j = i
              end
              i += 1
            end
          end
          if detallefact.blank? || fact_tv != 1
            dias = (fecha - fechaini).to_i + 1
            valor_concepto = plantilla.tarifa.valor
            valor_dia = valor_concepto / 30
            valor_fact = valor_dia * dias
            iva_concepto = Concepto.find(concepto_fact).porcentajeIva
            if iva_concepto > 0
              valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
              iva = valor_fact - valor_sin_iva
              valor_fact = valor_sin_iva
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
            facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
              fechaven: fecha.to_s, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
              estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
            if facturacion.save
              query = <<-SQL 
              SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
              SQL
              Orden.connection.clear_query_cache
              facturacion_id = Orden.connection.select_all(query)
              facturacion_id = (facturacion_id[0]["id"]).to_i
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
              prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_fact, cantidad: 1, 
              valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
              operacion: '+', usuario_id: usuario_id)
              if detallef.save
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
              return false
            end
          else
            fecha3 = Date.parse factura[j]["fechaven"].to_s
            dias_fact = (fecha1 - fecha3).to_i + 1 
            if dias_fact > 1
              valor_dia = tarifa / 30
              valor_mens = tarifa * dias_fact
              dias_fact = factura[j]["dias"] + dias_fact
              valor_fact = factura[j]["valor"] + valor_mens
              if dias_fact > 30 && valor_fact > tarifa
                dias_fact = 30
                valor_fact = tarifa
              end
              if iva_tv > 0
                valor_sin_iva = valor_fact / (iva_tv / 100 + 1)
                iva = valor_fact - valor_sin_iva
                valor_fact = valor_sin_iva
              end
              f_fin_d = Date.parse f_fin.to_s
              query = <<-SQL 
              UPDATE facturacion set fechaven = '#{f_fin_d}', valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact}, observacion = '#{observa}' WHERE nrofact = #{factura[j]["nrofact"]};
              UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_tv}, iva = #{iva}, observacion = 'TELEVISION' + ' ' + '#{nombre_mes}' WHERE nrofact = #{factura[j]["nrofact"]};
              SQL
              Facturacion.connection.select_all(query)
              valor_f = factura[j]["valor"]
              valor_iva = factura[j]["iva"]
              fact_id = factura[j]["id"]
              fact_doc = factura[j]["documento_id"]
              fact_prefijo = factura[j]["prefijo"]
              fact_nrofact = factura[j]["nrofact"]
            end
          end
        end
      end
      if plantilla.update(estado_id: estado, fechaini: fechaven)
        return true
      else
        return false
      end
    when 17, 18
      estadoD_1 = Estado.find_by(abreviatura: 'PA').id
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
      if orden[0]["concepto_id"] == 17
        doc = 1
        concepto_fact = 3
        observa_d = 'TELEVISION'
      else
        doc = 2
        concepto_fact = 4
        observa_d = 'INTERNET'
      end
      plantilla = PlantillaFact.find_by(entidad_id: orden[0]["entidad_id"], concepto_id: concepto_fact)
      if ban == 1
        if senal.tipo_facturacion_id == tipo_fact_ven
          query = <<-SQL 
          SELECT * FROM facturacion WHERE entidad_id = #{orden[0]["entidad_id"]} and (SELECT DATEPART(year, fechatrn)) = #{ano} and (SELECT DATEPART(month, fechatrn)) = #{mes};
          SQL
          Facturacion.connection.clear_query_cache
          factura = Facturacion.connection.select_all(query)
          i = 0
          j = 0
          fact_tv = 0
          detallefact = ''
          unless factura.blank?
            factura.each do |row|
              detallefact = DetalleFactura.where(nrofact: row["nrofact"])
              if (detallefact[0]["concepto_id"] == concepto_fact) 
                fact_tv = 1
                j = i
              end
              i += 1
            end
          end
          if detallefact.blank? || fact_tv != 1
            dias = (fecha - fechaini).to_i + 1
            valor_concepto = plantilla.tarifa.valor
            valor_dia = valor_concepto / 30
            valor_fact = valor_dia * dias
            iva_concepto = Concepto.find(concepto_fact).porcentajeIva
            if iva_concepto > 0
              valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
              iva = valor_fact - valor_sin_iva
              valor_fact = valor_sin_iva
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
            facturacion = Facturacion.new(entidad_id: orden[0]["entidad_id"], documento_id: doc, fechatrn: fecha.to_s,
              fechaven: fecha.to_s, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
              estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
            if facturacion.save
              query = <<-SQL 
              SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact};
              SQL
              Orden.connection.clear_query_cache
              facturacion_id = Orden.connection.select_all(query)
              facturacion_id = (facturacion_id[0]["id"]).to_i
              detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
              prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_fact, cantidad: 1, 
              valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
              operacion: '+', usuario_id: usuario_id)
              if detallef.save
                factura_orden = FacturaOrden.new(factura_id: facturacion_id, documento_id: facturacion.documento_id,
                  prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden[0]["id"], concepto_id: orden[0]["concepto_id"],
                  nrorden: orden[0]["nrorden"], usuario_id: usuario_id)
                unless factura_orden.save
                  return false
                end
                valor_f = facturacion.valor
                valor_iva = facturacion.iva
                fact_id = facturacion_id
                fact_doc = facturacion.documento_id
                fact_prefijo = facturacion.prefijo
                fact_nrofact = facturacion.nrofact
              else
                return false
              end
            else
              return false
            end
          else
            fecha3 = Date.parse factura[j]["fechaven"].to_s
            dias_fact = (fecha1 - fecha3).to_i + 1 
            if dias_fact > 1
              valor_dia = tarifa / 30
              valor_mens = tarifa * dias_fact
              dias_fact = factura[j]["dias"] + dias_fact
              valor_fact = factura[j]["valor"] + valor_mens
              if dias_fact > 30 && valor_fact > tarifa
                dias_fact = 30
                valor_fact = tarifa
              end
              if iva_tv > 0
                valor_sin_iva = valor_fact / (iva_tv / 100 + 1)
                iva = valor_fact - valor_sin_iva
                valor_fact = valor_sin_iva
              end
              f_fin_d = Date.parse f_fin.to_s
              query = <<-SQL 
              UPDATE facturacion set fechaven = '#{f_fin_d}', valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact}, observacion = '#{observa}' WHERE nrofact = #{factura[j]["nrofact"]};
              UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_tv}, iva = #{iva}, observacion = 'TELEVISION' + ' ' + '#{nombre_mes}' WHERE nrofact = #{factura[j]["nrofact"]};
              SQL
              Facturacion.connection.select_all(query)
              valor_f = factura[j]["valor"]
              valor_iva = factura[j]["iva"]
              fact_id = factura[j]["id"]
              fact_doc = factura[j]["documento_id"]
              fact_prefijo = factura[j]["prefijo"]
              fact_nrofact = factura[j]["nrofact"]
            end
          end
          query = <<-SQL 
          SELECT * FROM anticipos WHERE entidad_id = #{orden[0]["entidad_id"]} and (SELECT DATEPART(year, fechatrn)) = #{ano} and (SELECT DATEPART(month, fechatrn)) = #{mes} and servicio_id = #{doc};
          SQL
          Facturacion.connection.clear_query_cache
          anticipo = Facturacion.connection.select_all(query)
          unless anticipo.blank?
            valor_total = valor_f + valor_iva
            if anticipo[0]["valor"] >= valor_total
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{fact_id}, doc_factura_id = #{fact_doc}, prefijo = #{fact_prefijo}, nrofact = #{fact_nrofact} WHERE id = #{anticipo[0]["id"]};
              UPDATE facturacion set estado_id = #{estadoD_1} WHERE id = #{fact_id};
              SQL
            else
              query = <<-SQL 
              UPDATE anticipos set factura_id = #{fact_id}, doc_factura_id = #{fact_doc}, prefijo = #{fact_prefijo}, nrofact = #{fact_nrofact} WHERE id = #{anticipo[0]["id"]};
              SQL
            end
            Facturacion.connection.select_all(query)
          end
        end
      end
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    end
  end

  def self.anular_orden(orden)
    resp = 0
    ban = 0
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
        UPDATE ordenes set estado_id = 7, observacion = 'ANULADA' WHERE id = #{orden[0]["id"]};
        SQL
        Orden.connection.select_all(query)
        return resp = 1
      end
    end
  end
end
