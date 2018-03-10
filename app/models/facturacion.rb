class Facturacion < ApplicationRecord
  require 'date'
  extend NombreMeses

  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :documento, :fechatrn, :fechaven, :valor, :iva, :dias, :prefijo, :nrofact,
  :estado, :reporta, :usuario, presence: true #obligatorio

  private

  def self.generar_facturacion(f_elaboracion, f_inicio, f_fin, f_vence, f_corte, f_vencidos, observa, zona, usuario_id)
    notasfact = NotaFact.find_by(fechaElaboracion: f_elaboracion)
    if notasfact
      return false
    else
      documentos = Parametro.find_by(descripcion: 'Maneja internet en documentos separado')
      concepto_tv = Concepto.find_by(nombre: 'MENSUALIDAD TELEVISION')
      concepto_tv_id = concepto_tv.id
      iva_tv = concepto_tv.porcentajeIva
      concepto_int = Concepto.find_by(nombre: 'MENSUALIDAD INTERNET')
      concepto_int_id = concepto_int.id
      iva_int = concepto_int.porcentajeIva
      iva = 0
      estado = Estado.find_by(nombre: 'Activo').id
      fecha1 = ''
      fecha2 = ''
      pref = Resolucion.last.prefijo
      consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
      estadoD = Estado.find_by(abreviatura: 'PE')
      t = Time.now
      nombre_mes = Facturacion.mes(t.strftime("%B"))
      result = 0
      result1 = 0
      byebug
      if (zona == 'Todos')
        senales = Senal.all
        NotaFact.create(fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
      else
        zona = Zona.find_by(nombre: zona)
        senales = Senal.where(zona_id: zona.id)
        NotaFact.create(zona_id: zona.id, fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
      end
      fecha1 = Date.parse f_fin
      mes = fecha1.month
      ano = fecha1.year
      if (documentos.valor == 'S')
        senales.each do |senal|
          plantillas = PlantillaFact.where("concepto_id = #{concepto_tv_id} and senal_id = #{senal.id}")
          plantillas.each do |plantilla|
            if (senal.id == plantilla.senal_id)
              if (plantilla.estado_id == estado)
                if (plantilla.fechaini < f_fin) and (plantilla.fechafin > f_fin)
                  tarifa_tv = plantilla.tarifa.valor
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if (dias < 30)
                    if (fecha1.month == 2)
                      valor_mens = tarifa_tv
                    end
                    valor_dia = tarifa_tv / 30
                    valor_mens = tarifa_tv * dias
                  else
                    valor_mens = tarifa_tv
                    dias = 30
                  end
                  entidad = Entidad.find(senal.entidad_id).persona_id
                  condfisica = Persona.find(entidad).condicionfisica
                  if (condfisica == 'D')
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_mens * (porcentaje / 100)
                    valor_mens = valor_mens - descuento
                  end
                  if (iva_tv > 0)
                    valor_sin_iva = valor_mens / (iva_tv / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                  SQL
                  ActiveRecord::Base.connection.clear_query_cache
                  factura = ActiveRecord::Base.connection.select_all(query)
                  if factura.blank?
                    if (consecutivos == 'S')
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
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: 1, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                      if facturacion.save
                        query = <<-SQL 
                        SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
                        SQL
                        ActiveRecord::Base.connection.clear_query_cache
                        facturacion_id = ActiveRecord::Base.connection.select_all(query)
                        facturacion_id = (facturacion_id[0]["id"]).to_i
                        detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_tv_id, cantidad: 1, 
                        valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
                        operacion: '+', usuario_id: usuario_id)
                        if detallef.save
                          result = 1
                        else
                          result1 = 2
                        end
                      end
                  else
                    query = <<-SQL 
                    SELECT * FROM detalle_factura WHERE nrofact=#{factura[0]["nrofact"]};
                    SQL
                    ActiveRecord::Base.connection.clear_query_cache
                    detallefact = ActiveRecord::Base.connection.select_all(query)
                    dias_fact = factura[0]["dias"] + dias
                    valor_fact = factura[0]["valor"] + valor_mens
                    if (dias_fact < 30) and (valor_fact < tarifa_tv)
                      factura.update_all(fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias_fact)
                      detallefact.update_all(valor: valor_fact, porcentajeIva: iva_tv, iva: iva)
                      result = 1
                    end            
                  end
                end
              end
            end
          end
          plantillas = PlantillaFact.where("concepto_id = #{concepto_int_id} and senal_id = #{senal.id}")
          plantillas.each do |plantilla|
            if (senal.id == plantilla.senal_id)
              if (plantilla.estado_id == estado)
                if (plantilla.fechaini < f_fin) and (plantilla.fechafin > f_fin)
                  tarifa_tv = plantilla.tarifa.valor
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if (dias < 30)
                    if (fecha1.month == 2)
                      valor_mens = tarifa_tv
                    end
                    valor_dia = tarifa_tv / 30
                    valor_mens = tarifa_tv * dias
                  else
                    valor_mens = tarifa_tv
                    dias = 30
                  end
                  entidad = Entidad.find(senal.entidad_id).persona_id
                  condfisica = Persona.find(entidad).condicionfisica
                  if (condfisica == 'D')
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_mens * (porcentaje / 100)
                    valor_mens = valor_mens - descuento
                  end
                  if (iva_tv > 0)
                    valor_sin_iva = valor_mens / (iva_tv / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                  SQL
                  ActiveRecord::Base.connection.clear_query_cache
                  factura = ActiveRecord::Base.connection.select_all(query)
                  if factura.blank?
                    if (consecutivos == 'S')
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
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: 1, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                      if facturacion.save
                        query = <<-SQL 
                        SELECT id FROM facturacion WHERE nrofact=#{@facturacion.nrofact};
                        SQL
                        ActiveRecord::Base.connection.clear_query_cache
                        facturacion_id = ActiveRecord::Base.connection.select_all(query)
                        facturacion_id = (facturain_id[0]["id"]).to_i
                        @detallef = DetalleFactura.create(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_int_id, cantidad: 1, 
                        valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
                        operacion: '+', usuario_id: usuario_id)
                      end
                  else
                    query = <<-SQL 
                    SELECT * FROM detalle_factura WHERE nrofact=#{factura[0]["nrofact"]};
                    SQL
                    ActiveRecord::Base.connection.clear_query_cache
                    detallefact = ActiveRecord::Base.connection.select_all(query)
                    dias_fact = factura[0]["dias"] + dias
                    valor_fact = factura[0]["valor"] + valor_mens
                    if (dias_fact < 30) and (valor_fact < tarifa_tv)
                      factura.update_all(fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias_fact)
                      detallefact.update_all(valor: valor_fact, porcentajeIva: iva_tv, iva: iva)
                    end            
                  end
                end
              end
            end
          end
          plantillas = PlantillaFact.where("concepto_id <> '#{concepto_tv_id}' and concepto_id <> '#{concepto_int_id}' and senal_id = #{senal.id}")
          plantillas.each do |plantilla|
            concepto = plantilla.concepto_id
            iva = Concepto.find(concepto).porcentajeIva
            if (senal.id == plantilla.senal_id)
              if (plantilla.estado_id == estado)
                if (plantilla.fechaini < f_fin) and (plantilla.fechafin > f_fin)
                  tarifa_tv = plantilla.tarifa.valor
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if (dias < 30)
                    if (fecha1.month == 2)
                      valor_mens = tarifa_tv
                    end
                    valor_dia = tarifa_tv / 30
                    valor_mens = tarifa_tv * dias
                  else
                    valor_mens = tarifa_tv
                    dias = 30
                  end
                  entidad = Entidad.find(senal.entidad_id).persona_id
                  condfisica = Persona.find(entidad).condicionfisica
                  if (condfisica == 'D')
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_mens * (porcentaje / 100)
                    valor_mens = valor_mens - descuento
                  end
                  if (iva > 0)
                    valor_sin_iva = valor_mens / (iva / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                  SQL
                  ActiveRecord::Base.connection.clear_query_cache
                  factura = ActiveRecord::Base.connection.select_all(query)
                  if factura.blank?
                    if (consecutivos == 'S')
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
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: 1, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                      if facturacion.save
                        query = <<-SQL 
                        SELECT id FROM facturacion WHERE nrofact=#{@facturacion.nrofact};
                        SQL
                        ActiveRecord::Base.connection.clear_query_cache
                        facturacion_id = ActiveRecord::Base.connection.select_all(query)
                        facturacion_id = (facturain_id[0]["id"]).to_i
                        @detallef = DetalleFactura.create(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto, cantidad: 1, 
                        valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
                        operacion: '+', usuario_id: usuario_id)
                      end
                  else
                    query = <<-SQL 
                    SELECT * FROM detalle_factura WHERE nrofact=#{factura[0]["nrofact"]};
                    SQL
                    ActiveRecord::Base.connection.clear_query_cache
                    detallefact = ActiveRecord::Base.connection.select_all(query)
                    dias_fact = factura[0]["dias"] + dias
                    valor_fact = factura[0]["valor"] + valor_mens
                    if (dias_fact < 30) and (valor_fact < tarifa_tv)
                      factura.update_all(fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias_fact)
                      detallefact.update_all(valor: valor_fact, porcentajeIva: iva_tv, iva: iva)
                    end            
                  end
                end
              end
            end
          end
        end
      else
        senales.each do |senal|
          plantillas = PlantillaFact.where("senal_id =  #{senal.id}")
          plantillas.each do |plantilla|
            concepto = plantilla.concepto_id
            iva = Concepto.find(concepto).porcentajeIva
            if (senal.id == plantilla.senal_id)
              if (plantilla.estado_id == estado)
                if (plantilla.fechaini < f_fin) and (plantilla.fechafin > f_fin)
                  tarifa_tv = plantilla.tarifa.valor
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if (dias < 30)
                    if (fecha1.month == 2)
                      valor_mens = tarifa_tv
                    end
                    valor_dia = tarifa_tv / 30
                    valor_mens = tarifa_tv * dias
                  else
                    valor_mens = tarifa_tv
                    dias = 30
                  end
                  entidad = Entidad.find(senal.entidad_id).persona_id
                  condfisica = Persona.find(entidad).condicionfisica
                  if (condfisica == 'D')
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_mens * (porcentaje / 100)
                    valor_mens = valor_mens - descuento
                  end
                  if (iva > 0)
                    valor_sin_iva = valor_mens / (iva / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  query = <<-SQL 
                  SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                  SQL
                  ActiveRecord::Base.connection.clear_query_cache
                  factura = ActiveRecord::Base.connection.select_all(query)
                  if factura.blank?
                    if (consecutivos == 'S')
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
                    facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: 1, fechatrn: f_elaboracion,
                      fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                      estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                      if facturacion.save
                        query = <<-SQL 
                        SELECT id FROM facturacion WHERE nrofact=#{@facturacion.nrofact};
                        SQL
                        ActiveRecord::Base.connection.clear_query_cache
                        facturacion_id = ActiveRecord::Base.connection.select_all(query)
                        facturacion_id = (facturain_id[0]["id"]).to_i
                        detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto, cantidad: 1, 
                        valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
                        operacion: '+', usuario_id: usuario_id)
                        if detallef.save
                          result = 1
                        else
                          result1 = 2
                        end
                      end
                  else
                    query = <<-SQL 
                    SELECT * FROM detalle_factura WHERE nrofact=#{factura[0]["nrofact"]};
                    SQL
                    ActiveRecord::Base.connection.clear_query_cache
                    detallefact = ActiveRecord::Base.connection.select_all(query)
                    dias_fact = factura[0]["dias"] + dias
                    valor_fact = factura[0]["valor"] + valor_mens
                    if (dias_fact < 30) and (valor_fact < tarifa_tv)
                      factura.update_all(fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias_fact)
                      detallefact.update_all(valor: valor_fact, porcentajeIva: iva_tv, iva: iva)
                      result = 1
                    else
                      result1 = 2
                    end            
                  end
                end
              end
            end
          end
        end
      end
      if (result1 != 2)
        return true
      end
    end
  end
end