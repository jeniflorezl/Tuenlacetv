class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, detalle, observacion, tecnico_id, 
    solicita, zonaNue, barrioNue, direccionNue, usuario_id)
    t = Time.now
    t = Date.parse t
    mes = t.month
    ano = t.day
    fechaini = '01/#{mes}/{ano}'
    fechaini = Date.parse fechaini
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
          else
            return false
          end
        end
      end
    when "7", "8"
      if senal.tipo_facturacion_id == tipo_fact_ven
        dias = (t - fechaini).to_i + 1
        if concepto_id == "7"
          concepto = Concepto.find(3)
          valor_concepto = concepto.valor
          observa_d = 'TELEVISION'
        else
          concepto = Concepto.find(4)
          valor_concepto = concepto.valor
          observa_d = 'INTERNET'
        end
        valor_fact = valor_concepto * dias
        iva_concepto = concepto.iva
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
        facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc, fechatrn: fechaven,
          fechaven: fechaven, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
          estado_id: 6, observacion: 'MENSUALIDAD' + ' ' + nombre_mes, reporta: '0', usuario_id: usuario_id)
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
    else "17", "18"
  end
end
