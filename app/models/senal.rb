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
    conceptord = Concepto.find(11)
    conceptoplant = Concepto.find(3)
    conceptofact = Concepto.find(1)
    doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
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
        fechaven: senal.fechacontrato, nrorden: ultimo, estado_id: @estadoD, observacion: 'Registro creado en proceso de afiliación',
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
          if valorDcto > 0
            valor = valorAfiTv - valorDcto
          else
            valor = valorAfiTv
          end
          iva_cpto = conceptofact.porcentajeIva
          if iva_cpto > 0
            valor_sin_iva = valor / (iva_cpto / 100 + 1)
            iva = valor - valor_sin_iva
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
    conceptord = Concepto.find(12)
    conceptoplant = Concepto.find(4)
    conceptofact = Concepto.find(2)
    doc = Documento.find_by(nombre: 'FACTURA DE VENTA').id
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
      ordenin = Orden.new(entidad_id: entidad.id, concepto_id: conceptord.id, fechatrn: @t.strftime("%d/%m/%Y %H:%M:%S"),
      fechaven: @t.strftime("%d/%m/%Y %H:%M:%S"), nrorden: ultimo, estado_id: @estadoD, observacion: 'Registro creado en proceso de afiliación',
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
          if valorDcto > 0
            valor = valorAfiInt - valorDcto
          else
            valor = valorAfiInt
          end
          iva_cpto = conceptofact.porcentajeIva
          if iva_cpto > 0
            valor_sin_iva = valor / (iva_cpto / 100 + 1)
            iva = valor - valor_sin_iva
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

  def self.eliminar_suscriptor(entidad, persona, senal, info_internet, plantilla_tv, plantilla_int)
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
      query = <<-SQL
      SELECT id FROM ordenes WHERE entidad_id = #{entidad.id}; 
      SQL
      orden_id = Senal.connection.select_all(query)
      unless orden_id.blank?
        orden_id.each do |o|
          query = <<-SQL
          DELETE detalle_orden WHERE orden_id = #{o["id"]}; 
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

  def self.rango_fechas(f_ini, f_fin)
    senales = Senal.where("fechacontrato >= '#{f_ini}' and fechacontrato <= '#{f_fin}'")
    senales
  end

  def self.senales_consol
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
    senal
  end

  def self.senales_tv
      query = <<-SQL 
      SELECT * FROM VwSenales WHERE funcion_id = 1 and tv = 1;
      SQL
      Senal.connection.clear_query_cache
      senal = Senal.connection.select_all(query)
      senal
  end

  def self.senales_int
      query = <<-SQL 
      SELECT * FROM VwSenales WHERE funcion_id = 1 and internet = 1;
      SQL
      Senal.connection.clear_query_cache
      senal = Senal.connection.select_all(query)
      senal
  end

  def self.instalaciones_consol
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 11 or concepto_id = 12;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    instalaciones
  end

  def self.cortes_consol
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 7 or concepto_id = 8;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    cortes
  end

  def self.traslados_consol
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 13 or concepto_id = 14;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    traslados
  end

  def self.reconexiones_consol
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 15 or concepto_id = 16;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    reconexiones
  end

  def self.instalaciones_tv
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 11;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    instalaciones
  end

  def self.cortes_tv
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 7;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    cortes
  end

  def self.traslados_tv
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 13;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    traslados
  end

  def self.reconexiones_tv
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 15;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    reconexiones
  end

  def self.instalaciones_int
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 12;
    SQL
    Senal.connection.clear_query_cache
    instalaciones = Senal.connection.select_all(query)
    instalaciones
  end

  def self.cortes_int
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 8;
    SQL
    Senal.connection.clear_query_cache
    cortes = Senal.connection.select_all(query)
    cortes
  end

  def self.traslados_int
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 14;
    SQL
    Senal.connection.clear_query_cache
    traslados = Senal.connection.select_all(query)
    traslados
  end

  def self.reconexiones_int
    query = <<-SQL 
    SELECT * FROM VwOrdenes WHERE concepto_id = 16;
    SQL
    Senal.connection.clear_query_cache
    reconexiones = Senal.connection.select_all(query)
    reconexiones
  end
end
