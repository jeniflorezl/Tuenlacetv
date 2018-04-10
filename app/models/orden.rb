class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, detalle, observacion, tecnico_id, 
    solicita, zonaNue, barrioNue, direccionNue, usuario_id)
    fecha = Date.parse fechatrn
    mes = fecha.month
    ano = fecha.day
    fechaini = '01/#{mes}/{ano}'
    fechaini = Date.parse fechaini
    fechafin = '30/#{mes}/{ano}'
    fechafin = Date.parse fechafin
    senal = Senal.where(entidad_id: entidad_id)
    pref = Resolucion.last.prefijo
    tipo_fact_ant = TipoFacturacion.find_by(nombre: 'ANTICIPADA').id
    tipo_fact_ven = TipoFacturacion.find_by(nombre: 'VENCIDA').id
    nombre_mes = Orden.mes(f_fact.strftime("%B"))
    observacion = observacion.upcase! unless observacion == observacion.upcase
    consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
    if consecutivos == 'S'
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=#{concepto_id};
      SQL
    else
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes;
      SQL
    end
    Orden.connection.clear_query_cache
    ultimo = Orden.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo=1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    orden = Orden.new(entidad_id: entidad_id, concepto_id: concepto_id, fechatrn: fechatrn, fechaven: fechaven,
      nrorden: ultimo, estado_id: 6, observacion: observacion, tecnico_id: tecnico_id, usuario_id: usuario_id)
    if orden.save
      query = <<-SQL 
      SELECT id FROM ordenes WHERE nrorden=#{orden.nrorden};
      SQL
      Orden.connection.clear_query_cache
      orden_id = Orden.connection.select_all(query)
      orden_id = (orden_id[0]["id"]).to_i
      detalle.each do |d|
        detalle_orden = DetalleOrden.create(orden_id: orden_id, concepto_id: orden.concepto_id, nrorden: orden.nrorden,
          articulo_id: d["articulo_id"], cantidad: d["cantidad"], valor: d["valor"], porcentajeIva: d["porcentajeIva"],
          iva: d["iva"], costo: d["total"], observacion: observacion, usuario_id: usuario_id)
      end
      MvtoRorden.create(registro_orden_id: 1, orden_id: orden_id, concepto_id: orden.concepto_id,
        nrorden: orden.nrorden, valor: fechatrn, usuario_id: usuario_id)
      MvtoRorden.create(registro_orden_id: 2, orden_id: orden_id, concepto_id: orden.concepto_id,
        nrorden: orden.nrorden, valor: usuario_id, usuario_id: usuario_id)
      MvtoRorden.create(registro_orden_id: 3, orden_id: orden_id, concepto_id: orden.concepto_id,
        nrorden: orden.nrorden, valor: tecnico_id, usuario_id: usuario_id)
      MvtoRorden.create(registro_orden_id: 11, orden_id: orden_id, concepto_id: orden.concepto_id,
        nrorden: orden.nrorden, valor: solicita, usuario_id: usuario_id)
    end
    case concepto_id
    when "5", "6", "9", "10", "19", "20"
      if valor > 0
        if concepto_id == "5" || concepto_id == "9" || concepto_id == "19"
          doc = 1
        else
          doc = 2
        end
        concepto = Concepto.find(concepto_id)
        observa = concepto.nombre
        iva_concepto = concepto.iva
        if iva_concepto > 0
          valor_sin_iva = valor / (iva_concepto / 100 + 1)
          iva = valor - valor_sin_iva
          valor = valor_sin_iva
        end
        if consecutivos == 'S'
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc};
          SQL
        else
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion;
          SQL
        end
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
          SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
          SQL
          Orden.connection.clear_query_cache
          facturacion_id = Orden.connection.select_all(query)
          facturacion_id = (facturacion_id[0]["id"]).to_i
          detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
          operacion: '+', usuario_id: usuario_id)
          if detallef.save
            return true
            FacturaOrden.create(factura_id: facturacion_id, documento_id: facturacion.documento_id,
              facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
              nrorden: orden.nrorden, usuario_id: usuario_id)
          else
            return false
          end
        end
      end
    when "7", "8"
      if senal.tipo_facturacion_id == tipo_fact_ven
        dias = (fecha - fechaini).to_i + 1
        if concepto_id == "7"
          id = 3
          doc = 1
          observa_d = 'TELEVISION'
        else
          id = 4
          doc = 2
          observa_d = 'INTERNET'
        end
        valor_concepto = PlantillaFact.where("entidad_id = #{entidad_id} and concepto_id = #{id}").tarifa.valor
        valor_fact = valor_concepto * dias
        iva_concepto = Concepto.find(id).iva
        if iva_concepto > 0
          valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
          iva = valor_fact - valor_sin_iva
          valor_fact = valor_sin_iva
        end
        if consecutivos == 'S'
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc};
          SQL
        else
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion;
          SQL
        end
        Orden.connection.clear_query_cache
        ultimo = Orden.connection.select_all(query)
        if ultimo[0]["ultimo"] == nil
          ultimo = 1
        else
          ultimo = (ultimo[0]["ultimo"]).to_i + 1
        end
        facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fechaini.to_s,
          fechaven: fecha.to_s, valor: valor, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
          estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
        if facturacion.save
          query = <<-SQL 
          SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
          SQL
          Orden.connection.clear_query_cache
          facturacion_id = Orden.connection.select_all(query)
          facturacion_id = (facturacion_id[0]["id"]).to_i
          detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
          operacion: '+', usuario_id: usuario_id)
          if detallef.save
            return true
            FacturaOrden.create(factura_id: facturacion_id, documento_id: facturacion.documento_id,
              facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
              nrorden: orden.nrorden, usuario_id: usuario_id)
          else
            return false
          end
        end
      end
    when "13", "14"
      Traslado.create(orden_id: orden_id, concepto_id: concepto_id, nrorden: orden.nrorden, zonaAnt_id: senal.zona_id,
        barrioAnt_id: senal.barrio_id, direccionAnt: senal.direccion, zonaNue_id: zonaNue, barrioNue_id: barrioNue,
        direccionNue: direccionNue)
    when "15", "16"
      if senal.tipo_facturacion_id == tipo_fact_ant
        dias = (fechafin - fecha).to_i + 1
        if concepto_id == "15"
          id = 3
          doc = 1
          observa_d = 'TELEVISION'
        else
          id = 4
          doc = 2
          observa_d = 'INTERNET'
        end
        valor_concepto = PlantillaFact.where("entidad_id = #{entidad_id} and concepto_id = #{id}").tarifa.valor
        valor_fact = valor_concepto * dias
        iva_concepto = Concepto.find(id).iva
        if iva_concepto > 0
          valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
          iva = valor_fact - valor_sin_iva
          valor_fact = valor_sin_iva
        end
        if consecutivos == 'S'
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc};
          SQL
        else
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion;
          SQL
        end
        Orden.connection.clear_query_cache
        ultimo = Orden.connection.select_all(query)
        if ultimo[0]["ultimo"] == nil
          ultimo = 1
        else
          ultimo = (ultimo[0]["ultimo"]).to_i + 1
        end
        facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fecha.to_s,
          fechaven: fechafin.to_s, valor: valor, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
          estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
        if facturacion.save
          query = <<-SQL 
          SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
          SQL
          Orden.connection.clear_query_cache
          facturacion_id = Orden.connection.select_all(query)
          facturacion_id = (facturacion_id[0]["id"]).to_i
          detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
          operacion: '+', usuario_id: usuario_id)
          if detallef.save
            return true
            FacturaOrden.create(factura_id: facturacion_id, documento_id: facturacion.documento_id,
              facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
              nrorden: orden.nrorden, usuario_id: usuario_id)
          else
            return false
          end
        end
      end
    else "17", "18"
      if senal.tipo_facturacion_id == tipo_fact_ven
        dias = (fecha - fechaini).to_i + 1
        if concepto_id == "17"
          id = 3
          doc = 1
          observa_d = 'TELEVISION'
        else
          id = 4
          doc = 2
          observa_d = 'INTERNET'
        end
        valor_concepto = PlantillaFact.where("entidad_id = #{entidad_id} and concepto_id = #{id}").tarifa.valor
        valor_fact = valor_concepto * dias
        iva_concepto = Concepto.find(id).iva
        if iva_concepto > 0
          valor_sin_iva = valor_fact / (iva_concepto / 100 + 1)
          iva = valor_fact - valor_sin_iva
          valor_fact = valor_sin_iva
        end
        if consecutivos == 'S'
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc};
          SQL
        else
          query = <<-SQL 
          SELECT MAX(nrofact) as ultimo FROM facturacion;
          SQL
        end
        Orden.connection.clear_query_cache
        ultimo = Orden.connection.select_all(query)
        if ultimo[0]["ultimo"] == nil
          ultimo = 1
        else
          ultimo = (ultimo[0]["ultimo"]).to_i + 1
        end
        facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fechaini.to_s,
          fechaven: fecha.to_s, valor: valor, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
          estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '1', usuario_id: usuario_id)
        if facturacion.save
          query = <<-SQL 
          SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
          SQL
          Orden.connection.clear_query_cache
          facturacion_id = Orden.connection.select_all(query)
          facturacion_id = (facturacion_id[0]["id"]).to_i
          detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_concepto, iva: facturacion.iva, observacion: observa_d + ' ' + nombre_mes,
          operacion: '+', usuario_id: usuario_id)
          if detallef.save
            return true
            FacturaOrden.create(factura_id: facturacion_id, documento_id: facturacion.documento_id,
              facturacion.prefijo, nrofact: facturacion.nrofact, orden_id: orden_id, concepto_id: orden.concepto_id,
              nrorden: orden.nrorden, usuario_id: usuario_id)
          else
            return false
          end
        end
      end
    end
  end

  def editar_orden(orden, fechaven, solicita, tecnico_id, observacion, detalle, solucion, usuario_id)
    t = Time.now
    @orden.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
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
    query = <<-SQL 
    UPDATE ordenes set fechaven = #{fechaven}, tecnico_id = #{tecnico_id}, observacion: #{observacion}, fechacam = #{t.strftime("%d/%m/%Y %H:%M:%S").to_s} WHERE id = #{orden[0]["id"]};
    SQL
    Orden.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM detalle_orden WHERE orden_id = #{orden.id};
    SQL
    Orden.connection.clear_query_cache
    d_ordenes = Orden.connection.select_all(query)
    if d_ordenes.blank?
      detalle.each do |d|
        detalle_orden = DetalleOrden.create(orden_id: orden_id, concepto_id: orden.concepto_id, nrorden: orden.nrorden,
          articulo_id: d["articulo_id"], cantidad: d["cantidad"], valor: d["valor"], porcentajeIva: d["porcentajeIva"],
          iva: d["iva"], costo: d["total"], observacion: observacion, usuario_id: usuario_id)
      end
    else
      i = 0
      detalle.each do |d|
        if d_ordenes[i].blank?
          detalle_orden = DetalleOrden.create(orden_id: orden_id, concepto_id: orden.concepto_id, nrorden: orden.nrorden,
            articulo_id: d["articulo_id"], cantidad: d["cantidad"], valor: d["valor"], porcentajeIva: d["porcentajeIva"],
            iva: d["iva"], costo: d["total"], observacion: observacion, usuario_id: usuario_id)
        else
          d_ordenes[i].update(articulo_id: d["articulo_id"], cantidad: d["cantidad"], valor: d["valor"], 
            porcentajeIva: d["porcentajeIva"], iva: d["iva"], costo: d["total"], 
            observacion: observacion, usuario_id: usuario_id)
        end
        i++
      end
    end
    case orden.concepto_id
    when "7", "8"
      estado = Estado.find_by(abreviatura: 'C')
      if concepto_id == "7"
        id = 3
      else
        id = 4
      end
      plantilla = PlantillaFact.where("entidad_id = #{orden.entidad_id} and concepto_id = #{id}")
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    when "13", "14"
      traslado = Traslado.find_by(orden_id: orden.id)
      senal = Senal.find_by(entidad_id: orden.entidad_id)
      if senal.update(direccion: traslado.direccionNue, zona_id: traslado.zonaNue_id, barrio_id: barrioNue_id)
        return true
      else
        return false
      end
    when "15", "16"
      if concepto_id == "15"
        id = 3
      else
        id = 4
      end
      plantilla = PlantillaFact.where("entidad_id = #{orden.entidad_id} and concepto_id = #{id}")
      if plantilla.update(fechaini: fechaven)
        return true
      else
        return false
      end
    else "17", "18"
      estado = Estado.find_by(abreviatura: 'R')
      if concepto_id == "17"
        id = 3
      else
        id = 4
      end
      plantilla = PlantillaFact.where("entidad_id = #{orden.entidad_id} and concepto_id = #{id}")
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    end
  end

  def self.anular_orden(orden)
    case orden.concepto_id
    when "5", "6", "9", "10", "19", "20"
      query = <<-SQL 
      UPDATE ordenes set estado_id = 7, observacion = 'ANULADA' WHERE id = #{orden.id};
      UPDATE detalle_orden set articulo_id = null, cantidad = 0, valor = 0, porcentajeIva = 0, iva = 0, costo = 0, observacion = 'ANULADA' WHERE orden_id = #{orden.id};
      SQL
      Orden.connection.select_all(query)
    when "7", "8"
      estado = Estado.find_by(abreviatura: 'A')
      query = <<-SQL 
      UPDATE ordenes set estado_id = 7, observacion = 'ANULADA' WHERE id = #{orden.id};
      UPDATE detalle_orden set articulo_id = null, cantidad = 0, valor = 0, porcentajeIva = 0, iva = 0, costo = 0, observacion = 'ANULADA' WHERE orden_id = #{orden.id};
      SQL
      Orden.connection.select_all(query)
      if concepto_id == "7"
        id = 3
      else
        id = 4
      end
      plantilla = PlantillaFact.where("entidad_id = #{orden.entidad_id} and concepto_id = #{id}")
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    when "13", "14"
      query = <<-SQL 
      UPDATE ordenes set estado_id = 7, observacion = 'ANULADA' WHERE id = #{orden.id};
      UPDATE detalle_orden set articulo_id = null, cantidad = 0, valor = 0, porcentajeIva = 0, iva = 0, costo = 0, observacion = 'ANULADA' WHERE orden_id = #{orden.id};
      SQL
      Orden.connection.select_all(query)
      traslado = Traslado.find_by(orden_id: orden.id)
      senal = Senal.find_by(entidad_id: orden.entidad_id)
      if senal.update(direccion: traslado.direccionAnt, zona_id: traslado.zonaAnt_id, barrio_id: barrioAnt_id)
        return true
      else
        return false
      end
    when "15", "16"
      
    else "17", "18"
      estado = Estado.find_by(abreviatura: 'A')
      query = <<-SQL 
      UPDATE ordenes set estado_id = 7, observacion = 'ANULADA' WHERE id = #{orden.id};
      UPDATE detalle_orden set articulo_id = null, cantidad = 0, valor = 0, porcentajeIva = 0, iva = 0, costo = 0, observacion = 'ANULADA' WHERE orden_id = #{orden.id};
      SQL
      Orden.connection.select_all(query)
      if concepto_id == "17"
        id = 3
      else
        id = 4
      end
      plantilla = PlantillaFact.where("entidad_id = #{orden.entidad_id} and concepto_id = #{id}")
      if plantilla.update(estado_id: estado)
        return true
      else
        return false
      end
    end
  end
end
