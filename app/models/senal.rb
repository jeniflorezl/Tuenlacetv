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

  before_save :uppercase

  validates :entidad, :contrato, :direccion, :telefono1, :barrio, :zona, :fechacontrato,
  :tipo_instalacion, :tecnologia, :tiposervicio, :usuario, :tipo_facturacion, presence: true #obligatorio

  @t = Time.now
  @mes = Senal.mes(@t.strftime("%B"))
  @consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
  @estadoD = Estado.find_by(abreviatura: 'PE')
  @estadoU = Estado.find_by(abreviatura: 'P')

  def uppercase
    self.direccion.upcase!
    self.urbanizacion.upcase!
    self.torre.upcase!
    self.apto.upcase!
    self.vivienda.upcase!
    self.tiposervicio.upcase!
    self.areainstalacion.upcase!
  end

  private

  def self.afiliacion_tv(senal, entidad, valorAfiTv, valorDcto, tarifaTv, tecnico)
    ultimo = 0
    conceptord = Concepto.find(11)
    conceptoplant = Concepto.find(3)
    conceptofact = Concepto.find(1)
    plantilla = PlantillaFact.new(entidad_id: entidad.id, concepto_id: conceptoplant.id, estado_id: @estadoU.id, tarifa_id: tarifaTv, 
      fechaini: senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: senal.usuario_id)
    if plantilla.save
      if @consecutivos == 'S'
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=11;
        SQL
      else
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes;
        SQL
      end
      ActiveRecord::Base.connection.clear_query_cache
      ultimo = ActiveRecord::Base.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo=1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      orden = Orden.new(entidad_id: entidad.id, concepto_id: conceptord.id, fechatrn: senal.fechacontrato,
        fechaven: senal.fechacontrato, nrorden: ultimo, estado_id: @estadoD.id, observacion: 'Registro creado en proceso de afiliación',
        tecnico_id: tecnico, usuario_id: senal.usuario_id)
      if orden.save
        detalleo = DetalleOrden.new(orden_id: orden.id, concepto_id: orden.concepto_id, nrorden: orden.nrorden,
          cantidad: 0, valor: 0, porcentajeIva: 0, iva: 0, costo: 0, observacion: orden.observacion, usuario_id: orden.usuario_id)
        if detalleo.save
          if valorAfiTv > 0
            pref = Resolucion.last.prefijo
            if @consecutivos == 'S'
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=1;
              SQL
            else
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion;
              SQL
            end
            ActiveRecord::Base.connection.clear_query_cache
            ultimo = ActiveRecord::Base.connection.select_all(query)
            if ultimo[0]["ultimo"] == nil
              ultimo=1
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
            factura = Facturacion.new(entidad_id: entidad.id, documento_id: 1, fechatrn: senal.fechacontrato,
              fechaven: senal.fechacontrato, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
              estado_id: @estadoD.id, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id: senal.usuario_id)
            if factura.save
              query = <<-SQL 
              SELECT id FROM facturacion WHERE nrofact=#{factura.nrofact};
              SQL
              ActiveRecord::Base.connection.clear_query_cache
              factura_id = ActiveRecord::Base.connection.select_all(query)
              factura_id = (factura_id[0]["id"]).to_i
              detallef = DetalleFactura.new(factura_id: factura_id, documento_id: factura.documento_id, 
                prefijo: factura.prefijo, nrofact: factura.nrofact, concepto_id: conceptofact.id, cantidad: 1, 
                valor: factura.valor, porcentajeIva: iva_cpto, iva: iva, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN' + ' ' + @mes,
                operacion: '+', usuario_id: factura.usuario_id)
              if detallef.save
                return true
              end
            end 
          else   
            return true
          end
        end
      end
    end
  end


  def self.afiliacion_int(senal, entidad, valorAfiInt, valorDcto, tarifaInt, tecnico)
    ultimo = 0
    conceptord = Concepto.find(12)
    conceptoplant = Concepto.find(4)
    conceptofact = Concepto.find(2)
    plantillaint = PlantillaFact.new(entidad_id: entidad.id, concepto_id: conceptoplant.id, estado_id: @estadoU.id, tarifa_id: tarifaInt, 
      fechaini: senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: senal.usuario_id)
    if plantillaint.save
      if @consecutivos == 'S'
        query = <<-SQL  
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=12;
        SQL
      else
        query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes;
        SQL
      end
      ActiveRecord::Base.connection.clear_query_cache
      ultimo = ActiveRecord::Base.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo=1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      ordenin = Orden.new(entidad_id: entidad.id, concepto_id: conceptord.id, fechatrn: @t.strftime("%d/%m/%Y %H:%M:%S"),
      fechaven: @t.strftime("%d/%m/%Y %H:%M:%S"), nrorden: ultimo, estado_id: @estadoD.id, observacion: 'Registro creado en proceso de afiliación',
      tecnico_id: tecnico, usuario_id: senal.usuario_id)
      if ordenin.save
        detalleoin = DetalleOrden.new(orden_id: ordenin.id, concepto_id: ordenin.concepto_id, nrorden: ordenin.nrorden,
          cantidad: 0, valor: 0, porcentajeIva: 0, iva: 0, costo: 0, observacion: ordenin.observacion, usuario_id: ordenin.usuario_id)
        if detalleoin.save
          if valorAfiInt > 0
            pref = Resolucion.last.prefijo
            if @consecutivos == 'S'
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=2;
              SQL
            else
              query = <<-SQL 
              SELECT MAX(nrofact) as ultimo FROM facturacion;
              SQL
            end
            ActiveRecord::Base.connection.clear_query_cache
            ultimo = ActiveRecord::Base.connection.select_all(query)
            if ultimo[0]["ultimo"] == nil
              ultimo=1
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
            facturain = Facturacion.new(entidad_id: entidad.id, documento_id: 2, fechatrn: senal.fechacontrato,
              fechaven: senal.fechacontrato, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
              estado_id: @estadoD.id, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET', reporta: '0', usuario_id: senal.usuario_id)
            if facturain.save
              query = <<-SQL 
              SELECT id FROM facturacion WHERE nrofact=#{facturain.nrofact};
              SQL
              ActiveRecord::Base.connection.clear_query_cache
              facturain_id = ActiveRecord::Base.connection.select_all(query)
              facturain_id = (facturain_id[0]["id"]).to_i
              detallefin = DetalleFactura.new(factura_id: facturain_id, documento_id: facturain.documento_id, 
                prefijo: facturain.prefijo, nrofact: facturain.nrofact, concepto_id: conceptofact.id, cantidad: 1, 
                valor: facturain.valor, porcentajeIva: iva_cpto, iva: iva, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET' + ' ' + @mes,
                operacion: '+', usuario_id: facturain.usuario_id)
              if detallefin.save
                return true
              end
            end
          else
            return true
          end
        end
      end
    end
  end
end
