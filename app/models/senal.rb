class Senal < ApplicationRecord
  extend NombreMeses

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
  @mes = Senal.mes(@t.strftime("%B"))
  @consecutivos = Parametro.find(70).valor
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

  def self.proceso_afiliacion_tv(senal, entidad, valorAfiTv, tarifaTv, tecnico)
    @senal = senal
    @entidad = entidad
    ultimo = 0
    @conceptoord = Concepto.find_by(nombre: 'INSTALACION TELEVISION')
    @conceptoplant = Concepto.find_by(nombre: 'MENSUALIDAD TELEVISION')
    @conceptofact = Concepto.find_by(nombre: 'SUSCRIPCION TELEVISION')
    @plantilla = PlantillaFact.new(senal_id: @senal.id, concepto_id: @conceptoplant.id, estado_id: @estadoU.id, tarifa_id: tarifaTv, 
    fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
    if @plantilla.save
      if (@consecutivos == 'S')
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
      if (ultimo[0]["ultimo"] == nil)
        ultimo=1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      @orden = Orden.new(senal_id: @senal.id, concepto_id: @conceptoord.id, fechatrn: @senal.fechacontrato,
      fechaven: @senal.fechacontrato, nrorden:ultimo, estado_id: @estadoD.id, observacion: 'Registro creado en proceso de afiliación',
      tecnico_id: tecnico, usuario_id: @senal.usuario_id)
      if @orden.save
        if valorAfiTv > 0
          pref = Resolucion.last.prefijo
          if (@consecutivos == 'S')
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
          if (ultimo[0]["ultimo"] == nil)
            ultimo=1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          @factura = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
          fechaven: @senal.fechacontrato, valor: valorAfiTv, iva: 0, dias: 0, prefijo: pref, nrofact: ultimo,
          estado_id: @estadoD.id, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id:  @senal.usuario_id)
          if @factura.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact=#{@factura.nrofact};
            SQL
            ActiveRecord::Base.connection.clear_query_cache
            factura_id = ActiveRecord::Base.connection.select_all(query)
            factura_id = (factura_id[0]["id"]).to_i
            @detallef = DetalleFactura.new(factura_id: factura_id, documento_id: @factura.documento_id, 
            prefijo: @factura.prefijo, nrofact: @factura.nrofact, concepto_id: @conceptofact.id, cantidad: 1, 
            valor: @factura.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN' + ' ' + @mes,
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
    ultimo = 0
    @conceptoord = Concepto.find_by(nombre: 'INSTALACION INTERNET')
    @conceptoplant = Concepto.find_by(nombre: 'MENSUALIDAD INTERNET')
    @conceptofact = Concepto.find_by(nombre: 'SUSCRIPCION INTERNET')
    @plantillaint = PlantillaFact.new(senal_id: @senal.id, concepto_id: @conceptoplant.id, estado_id: @estadoU.id, tarifa_id: tarifaInt, 
    fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
    if @plantillaint.save
      if (@consecutivos == 'S')
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
      if (ultimo[0]["ultimo"] == nil)
        ultimo=1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      @ordenin = Orden.new(senal_id: @senal.id, concepto_id: @conceptoord.id, fechatrn: @t.strftime("%d/%m/%Y %H:%M:%S"),
      fechaven: @t.strftime("%d/%m/%Y %H:%M:%S"), nrorden: ultimo, estado_id: @estadoD.id, observacion: 'Registro creado en proceso de afiliación',
      tecnico_id: tecnico, usuario_id: @senal.usuario_id)
      if @ordenin.save
        if valorAfiInt > 0
          pref = Resolucion.last.prefijo
          if (@consecutivos == 'S')
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
          if (ultimo[0]["ultimo"] == nil)
            ultimo=1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          @facturain = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
          fechaven: @senal.fechacontrato, valor: valorAfiInt, iva: 0, dias: 0, prefijo: pref, nrofact: ultimo,
          estado_id: @estadoD.id, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET', reporta: '0', usuario_id:  @senal.usuario_id)
          if @facturain.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact=#{@facturain.nrofact};
            SQL
            ActiveRecord::Base.connection.clear_query_cache
            facturain_id = ActiveRecord::Base.connection.select_all(query)
            facturain_id = (facturain_id[0]["id"]).to_i
            @detallefin = DetalleFactura.new(factura_id: facturain_id, documento_id: @facturain.documento_id, 
            prefijo: @facturain.prefijo, nrofact: @facturain.nrofact, concepto_id: @conceptofact.id, cantidad: 1, 
            valor: @facturain.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE INTERNET' + ' ' + @mes,
            operacion: '+', usuario_id: @facturain.usuario_id)
            if @detallefin.save
              return true
            end
          end
        end
      end
    end
  end
end
