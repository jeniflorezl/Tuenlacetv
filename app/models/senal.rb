class Senal < ApplicationRecord
  belongs_to :entidad
  belongs_to :barrio
  belongs_to :zona
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  belongs_to :usuario

  before_save :uppercase

  validates :entidad, :contrato, :direccion, :telefono1, :barrio, :zona, :fechacontrato,
  :tipo_instalacion, :tecnologia, :tiposervicio, :usuario, presence: true #obligatorio

  @t = Time.now

  def uppercase
    self.direccion.upcase!
    self.urbanizacion.upcase!
    self.torre.upcase!
    self.apto.upcase!
    self.vivienda.upcase!
    self.tiposervicio.upcase!
    self.areainstalacion.upcase!
  end

  def self.proceso_afiliacion_tv(senal, entidad, valorAfiTv, tarifaTv, tecnico)
    @senal = senal
    @entidad = entidad
    result = 0
    @plantilla = PlantillaFact.new(senal_id: @senal.id, concepto_id: 3, estado_id: 4, tarifa_id: tarifaTv, 
    fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
    if @plantilla.save
      query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=11;
      SQL
      ultimo = ActiveRecord::Base.connection.select_all(query)
      if (ultimo[0]["ultimo"] == nil)
        ultimo=0
      else
        ultimo = ultimo[0]["ultimo"]
      end
      @orden = Orden.new(senal_id: @senal.id, concepto_id: 11, fechatrn: @senal.fechacontrato,
      fechaven: @senal.fechacontrato, nrorden: ultimo + 1, estado_id: 4, observacion: 'Registro creado en proceso de afiliación',
      tecnico_id: tecnico, usuario_id: @senal.usuario_id)
      if @orden.save
        if valorAfi > 0
          @pref = Resolucion.last.prefijo
          query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=1;
          SQL
          ultimo = ActiveRecord::Base.connection.select_all(query)
          if (ultimo[0]["ultimo"] == nil)
            ultimo=0
          else
            ultimo = ultimo[0]["ultimo"]
          end
          @factura = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
          fechaven: @senal.fechacontrato, valor: valorAfiTv, iva: 0, dias: 0, prefijo: pref, nrofact: ultimo + 1,
          estado_id: 4, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id:  @senal.usuario_id)
          if @factura.save
            @detallef = DetalleFactura.create(factura_id: @factura.id, prefijo: @factura.prefijo, nrofact: @factura.nrofact,
            concepto_id: 1, valor: @factura.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN',
            operacion: '+', usuario_id: @factura.usuario_id)
            if @detallef.save
              return true
            end
          end    
        end
      end
    end
  end


  def self.proceso_afiliacion_int(senal, entidad, valorAfiInt, tarifaInt, tecnico)
    @senal = senal
    @entidad = entidad
    @plantillaint = PlantillaFact.new(senal_id: @senal.id, concepto_id: 4, estado_id: 4, tarifa_id: tarifaInt, 
    fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
    if @plantillaint.save
      query = <<-SQL 
        SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=11;
      SQL
      ultimo = ActiveRecord::Base.connection.select_all(query)
      if (ultimo[0]["ultimo"] == nil)
        ultimo=0
      else
        ultimo = ultimo[0]["ultimo"]
      end
      @ordenin = Orden.new(senal_id: @senal.id, concepto_id: 12, fechatrn: @t.strftime("%d/%m/%Y %H:%M:%S"),
      fechaven: @t.strftime("%d/%m/%Y %H:%M:%S"), nrorden: ultimo + 1, estado_id: 4, observacion: 'Registro creado en proceso de afiliación',
      tecnico_id: tecnico, usuario_id: @senal.usuario_id)
      if @ordenin.save
        if params[:valorafi] > 0
          query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=1;
          SQL
          ultimo = ActiveRecord::Base.connection.select_all(query)
          if (ultimo[0]["ultimo"] == nil)
              ultimo=0
          else
            ultimo = ultimo[0]["ultimo"]
          end
          @facturain = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
          fechaven: @senal.fechacontrato, valor: valorAfiInt, iva: 0, dias: 0, prefijo: @pref, nrofact: ultimo + 1,
          estado_id: 4, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id:  @senal.usuario_id)
          if @facturain.save
            @detallefin = DetalleFactura.create(factura_id: @factura.id, prefijo: @factura.prefijo, nrofact: @factura.nrofact,
            concepto_id: 1, valor: @factura.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN',
            operacion: '+', usuario_id: @factura.usuario_id)
            if @detallefin.save
              return true
            end
          end
        end
      end
    end
  end
end
