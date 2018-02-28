class Senal < ApplicationRecord
  belongs_to :entidad
  belongs_to :servicio
  belongs_to :barrio
  belongs_to :zona
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  belongs_to :usuario

  before_save :uppercase

  validates :entidad, :servicio, :contrato, :direccion, :telefono1, :barrio, :zona, :fechacontrato,
  :tipo_instalacion, :tecnologia, :tiposervicio, :usuario, presence: true #obligatorio

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

  def proceso_afiliacion(@senal, tv, internet, valorAfi, tarifaTv, tarifaInt)
    if tv==1
      @plantilla = PlantillaFact.new(senal_id: @senal.id, concepto_id: 3, tarifa_id: tarifaTv, 
      fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
      if @plantilla.save
        ultimo = Orden.last.nrorden
        @orden = Orden.new(senal_id: @senal.id, concepto_id: 11, fechatrn: @senal.fechacontrato,
        fechaven: @senal.fechacontrato, nrorden: ultimo + 1, estado_id: 4, observacion: 'Registro creado en proceso de afiliación',
        tecnico_id: params[:tecnico_id], usuario_id: @senal.usuario_id)
        if @orden.save
          if valorAfi > 0
            ultimo = Facturacion.last.nrofact
            @factura = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
            fechaven: @senal.fechacontrato, valor: valorAfi, iva: 0, dias: 0, prefijo: 'A', nrofact: ultimo + 1,
            estado_id: 4, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id:  @senal.usuario_id)
            if @factura.save
              @detallef = DetalleFactura.create(factura_id: @factura.id, prefijo: @factura.prefijo, nrofact: @factura.nrofact,
              concepto_id: 1, valor: @factura.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN',
              operacion: '+', usuario_id: @factura.usuario_id)
              @detallef.save
            end    
          end
        end
      end
    end
    if internet==1
      @info_internet = InfoInternet.new(internet_params)
      @info_internet.senal_id = @senal.id
      if @info_internet.save
        @plantillaint = PlantillaFact.new(senal_id: @senal.id, concepto_id: 4, tarifa_id: tarifaTv, 
        fechaini: @senal.fechacontrato, fechafin: @t.strftime("%d/%m/2118 %H:%M:%S"), usuario_id: @senal.usuario_id)
        if @plantillaint.save
          ultimo = Orden.last.nrorden
          @ordenin = Orden.new(senal_id: @senal.id, concepto_id: 12, fechatrn: @t.strftime("%d/%m/%Y %H:%M:%S"),
          fechaven: @t.strftime("%d/%m/%Y %H:%M:%S"), nrorden: ultimo + 1, estado_id: 4, observacion: 'Registro creado en proceso de afiliación',
          tecnico_id: params[:tecnico_id], usuario_id: @senal.usuario_id)
          if @ordenin.save
            if params[:valorafi] > 0
              ultimo = Facturacion.last.nrofact
              @facturain = Facturacion.new(entidad_id: @entidad.id, documento_id: 1, fechatrn: @senal.fechacontrato,
              fechaven: @senal.fechacontrato, valor: valorAfi, iva: 0, dias: 0, prefijo: 'A', nrofact: ultimo + 1,
              estado_id: 4, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN', reporta: '0', usuario_id:  @senal.usuario_id)
              if @facturain.save
                @detallefin = DetalleFactura.create(factura_id: @factura.id, prefijo: @factura.prefijo, nrofact: @factura.nrofact,
                concepto_id: 1, valor: @factura.valor, porcentajeIva: 0, iva: 0, observacion: 'SUSCRIPCIÓN SERVICIO DE TELEVISIÓN',
                operacion: '+', usuario_id: @factura.usuario_id)
                @detallefin.save
              end
            end
          end
        end
      end
    end
  end
end
