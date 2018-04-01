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

  def self.facturaciones_generadas
    fact_generadas = Array.new
    i = 0
    ban = 0
    notas_fact = NotaFact.all
    byebug
    notas_fact.each do |nota|
      fecha_ela = nota["fechaElaboracion"]
      if  i == 1 && fecha_ela != fact_generadas[i-1]['f_elaboracion']
        ban = 1
      end
      if ban != 1
        fecha_ela = Date.parse fecha_ela.to_s
        fecha1 = self.formato_fecha(fecha_ela)
        fecha_inicio = nota["fechaInicio"]
        fecha2 = self.formato_fecha(fecha_inicio)
        fecha_fin = nota["fechaFin"]
        fecha_fin = Date.parse fecha_fin.to_s
        fecha3 = self.formato_fecha(fecha_fin)
        fecha_ven = nota["fechaVencimiento"]
        fecha4 = self.formato_fecha(fecha_ven)
        query = <<-SQL 
        SELECT nrofact FROM facturacion WHERE fechatrn >= '#{fecha_ela}' and fechaven <= '#{fecha_fin}' ORDER BY id;
        SQL
        Facturacion.connection.clear_query_cache
        factura = Facturacion.connection.select_all(query)
        fact_ini = factura.first
        nrofact_ini = fact_ini["nrofact"]
        fact_fin = factura.last
        nrofact_fin = fact_fin["nrofact"]
        fact_generadas[i] = { 'nrofact_ini' => nrofact_ini, 'nrofact_fin' => nrofact_fin, 'f_elaboracion' => fecha1,
        'f_inicio' => fecha2, 'f_fin' => fecha3, 'f_ven' => fecha4}
        i += 1
      end
    end
    fact_generadas
  end

  def self.formato_fecha(f)
    fecha_date = Date.parse f.to_s
    mes_f = fecha_date.month.to_s
    ano_f = fecha_date.year.to_s
    dia_f = fecha_date.day.to_s
    if mes_f.length == 1
      mes_f = '0' + mes_f
    end
    if dia_f.length == 1
      dia_f = '0' + dia_f
    end
    fecha = dia_f + '/' + mes_f + '/' + ano_f
    fecha
  end

  def self.generar_facturacion(tipo_fact, f_elaboracion, f_inicio, f_fin, f_vence, f_corte, f_vencidos, observa, zona, usuario_id)
    byebug
    fecha1_nota = Date.parse f_inicio.to_s
    #mes_f = fecha_elab.month.to_s
    #ano_f = fecha_elab.year.to_s
    #dia_f = fecha_elab.day.to_s
    #fecha1_nota = ano_f + '/' + mes_f + '/' + dia_f
    fecha2_nota = Date.parse f_fin.to_s
    #mes_f = fecha_elab.month.to_s
    #ano_f = fecha_elab.year.to_s
    #dia_f = fecha_elab.day.to_s 
    #fecha1_nota = self.formato_fecha(f_inicio)
    #fecha2_nota = self.formato_fecha(f_fin)
    resp = 0
    resp1 = 0
    respuesta = 0
    notasfact = NotaFact.where("fechaInicio = '#{fecha1_nota}' and fechaFin = '#{fecha2_nota}'")
    unless notasfact.blank?
      if notasfact[0]["zona_id"] == nil && zona == 'Todos'
        return respuesta = 3
      elsif notasfact[0]["zona_id"] == zona
        return respuesta = 4
      else
        zonas = Zona.all
        zonas.each do |z|
          notasfact.each do |row|
            if row["zona_id"] == z.id
              resp = 1
            end
          end
          if resp == 1
            if zona == z.id
              resp1 = 1
            end
          end
        end
      end
    end
    if resp1 == 1
      return respuesta = 4
    else
      documentos = Parametro.find_by(descripcion: 'Maneja internet en documentos separado')
      concepto_tv = Concepto.find(3)
      iva_tv = concepto_tv.porcentajeIva
      concepto_int = Concepto.find(4)
      iva_int = concepto_int.porcentajeIva
      iva = 0
      estado = Estado.find_by(nombre: 'Activo').id
      fecha1 = ''
      fecha2 = ''
      pref = Resolucion.last.prefijo
      consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
      estadoD = Estado.find_by(abreviatura: 'PE')
      doc_tv = Documento.find_by(nombre: 'FACTURA DE VENTA TELEVISION').id
      doc_int = Documento.find_by(nombre: 'FACTURA DE VENTA INTERNET').id
      t = Time.now
      nombre_mes = Facturacion.mes(t.strftime("%B"))
      result = 0
      result1 = 0
      if zona == 'Todos'
        senales = Senal.where(tipo_facturacion_id: tipo_fact)
        NotaFact.create(fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
      else
        senales = Senal.where("tipo_facturacion_id = #{tipo_fact} and zona_id = #{zona}")
        NotaFact.create(zona_id: zona, fechaElaboracion: f_elaboracion, fechaInicio: f_inicio, fechaFin: f_fin,
          fechaVencimiento: f_vence, fechaCorte: f_corte, fechaPagosVen: f_vencidos, usuario_id: usuario_id)
      end
      fecha1 = Date.parse f_fin
      mes = fecha1.month
      ano = fecha1.year
      if documentos.valor == 'S'
        senales.each do |senal|
          plantillas = PlantillaFact.where("concepto_id = #{concepto_tv.id} and entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            byebug
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
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
                    if (detallefact[0]["concepto_id"] == concepto_tv.id) 
                      fact_tv = 1
                      j = i
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_tv != 1
                  query = <<-SQL 
                  SELECT * FROM anticipos WHERE entidad_id = #{senal.entidad_id} and fechatrn = '#{f_inicio}';
                  SQL
                  Facturacion.connection.clear_query_cache
                  anticipo = Facturacion.connection.select_all(query)
                  if anticipo.blank?
                    fecha2 = Date.parse plantilla.fechaini.to_s
                    dias = (fecha1 - fecha2).to_i + 1
                    if dias < 30
                      if fecha1.month == 2
                        valor_mens = tarifa
                      else
                        valor_dia = tarifa / 30
                        valor_mens = valor_dia * dias
                      end
                    else
                      valor_mens = tarifa
                      dias = 30
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if senal.entidad.persona.condicionfisica == 'D'
                    byebug
                    porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                    descuento = valor_mens * (porcentaje.to_f / 100)
                    valor_mens = valor_mens - descuento
                  end
                  if iva_tv > 0
                    valor_sin_iva = valor_mens / (iva_tv / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  if consecutivos == 'S'
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_tv};
                    SQL
                  else
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion;
                    SQL
                  end
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo=1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc_tv, fechatrn: f_elaboracion,
                    fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                    estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                    if facturacion.save
                      query = <<-SQL 
                      SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact} and documento_id = #{doc_tv};
                      SQL
                      Facturacion.connection.clear_query_cache
                      facturacion_id = Facturacion.connection.select_all(query)
                      facturacion_id = (facturacion_id[0]["id"]).to_i
                      detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                        prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_tv.id, cantidad: 1, 
                        valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
                        operacion: '+', usuario_id: usuario_id)
                      if detallef.save
                        result = 1
                      else
                        result1 = 2
                      end
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
                    query = <<-SQL 
                    UPDATE facturacion set fechaven = #{f_fin}, valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact} WHERE nrofact = #{factura[j]["nrofact"]};
                    UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_tv}, iva = #{iva} WHERE nrofact = #{factura[j]["nrofact"]};
                    SQL
                    Facturacion.connection.select_all(query)
                    result = 1
                  end
                end
              end
            end
          end
        end
        senales.each do |senal|
          byebug
          plantillas = PlantillaFact.where("concepto_id = #{concepto_int.id} and entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_int = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    if detallefact[0]["concepto_id"] == concepto_int.id
                      fact_int = 1
                      j = i
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_int != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if iva_int > 0
                    valor_sin_iva = valor_mens / (iva_tv / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  if consecutivos == 'S'
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_int};
                    SQL
                  else
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion;
                    SQL
                  end
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo=1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc_int, fechatrn: f_elaboracion,
                    fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                    estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                  if facturacion.save
                    query = <<-SQL 
                    SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact} and documento_id = #{doc_int};
                    SQL
                    Facturacion.connection.clear_query_cache
                    facturacion_id = Facturacion.connection.select_all(query)
                    facturacion_id = (facturacion_id[0]["id"]).to_i
                    detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_int.id, cantidad: 1, 
                    valor: facturacion.valor, porcentajeIva: iva_int, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
                    operacion: '+', usuario_id: usuario_id)
                    if detallef.save
                      result = 1
                    else
                      result1 = 2
                    end
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
                    if iva_int > 0
                      valor_sin_iva = valor_fact / (iva_tv / 100 + 1)
                      iva = valor_fact - valor_sin_iva
                      valor_fact = valor_sin_iva
                    end
                    query = <<-SQL 
                    UPDATE facturacion set fechaven = #{f_fin}, valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact} WHERE nrofact = #{factura[j]["nrofact"]};
                    UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_int}, iva = #{iva} WHERE nrofact = #{factura[j]["nrofact"]};
                    SQL
                    Facturacion.connection.select_all(query)
                    result = 1
                  end
                end
              end
            end
          end
        end
        senales.each do |senal|
          byebug
          plantillas = PlantillaFact.where("concepto_id <> '#{concepto_tv.id}' and concepto_id <> '#{concepto_int.id}' and entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            concepto = plantilla.concepto_id
            iva_cpto = Concepto.find(concepto).porcentajeIva
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_concepto = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    if detallefact[0]["concepto_id"] == concepto
                      fact_concepto = 1
                      j = i
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_concepto != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if iva_cpto > 0
                    valor_sin_iva = valor_mens / (iva / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  if consecutivos == 'S'
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_tv};
                    SQL
                  else
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion;
                    SQL
                  end
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo=1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc_tv, fechatrn: f_elaboracion,
                    fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                    estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                  if facturacion.save
                    query = <<-SQL 
                    SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact} and documento_id = #{doc_tv};
                    SQL
                    Facturacion.connection.clear_query_cache
                    facturacion_id = Facturacion.connection.select_all(query)
                    facturacion_id = (facturacion_id[0]["id"]).to_i
                    detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto, cantidad: 1, 
                    valor: facturacion.valor, porcentajeIva: iva_cpto, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
                    operacion: '+', usuario_id: usuario_id)
                    if detallef.save
                      result = 1
                    else
                      result1 = 2
                    end
                  end
                else
                  fecha3 = Date.parse factura[j]["fechaven"].to_s
                  dias_fact = (fecha1 - fecha3).to_i + 1
                  if dias_fact > 1
                    valor_dia = tarifa / 30
                    valor_mens = tarifa * dias_fact
                    dias_fact = factura[j]["dias"] + dias_fact
                    valor_fact = factura[j]["valor"] + valor_mens
                    if dias_fact > 30 || valor_fact > tarifa
                      dias_fact = 30
                      valor_fact = tarifa
                    end
                    if iva > 0
                      valor_sin_iva = valor_fact / (iva / 100 + 1)
                      iva = valor_fact - valor_sin_iva
                      valor_fact = valor_sin_iva
                    end
                    query = <<-SQL 
                    UPDATE facturacion set fechaven = #{f_fin}, valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact} WHERE nrofact = #{factura[j]["nrofact"]};
                    UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_cpto}, iva = #{iva} WHERE nrofact = #{factura[j]["nrofact"]};
                    SQL
                    Facturacion.connection.select_all(query)
                    result = 1
                  end
                end
              end
            end
          end
        end
      else
        senales.each do |senal|
          plantillas = PlantillaFact.where("entidad_id = #{senal.entidad_id}")
          plantillas.each do |plantilla|
            byebug
            concepto_id = plantilla.concepto_id
            concepto = Concepto.find(concepto_id)
            observacion_d = concepto.nombre
            iva_cpto = concepto.porcentajeIva
            doc_fact = doc_tv
            if plantilla.estado_id == estado
              if plantilla.fechaini < f_fin && plantilla.fechafin > f_fin
                tarifa = plantilla.tarifa.valor
                query = <<-SQL 
                SELECT * FROM facturacion WHERE entidad_id = #{senal.entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
                SQL
                Facturacion.connection.clear_query_cache
                factura = Facturacion.connection.select_all(query)
                i = 0
                j = 0
                fact_concepto = 0
                detallefact = ''
                unless factura.blank?
                  factura.each do |row|
                    detallefact = DetalleFactura.where(nrofact: row["nrofact"])
                    if detallefact[0]["concepto_id"] == concepto_id
                      fact_concepto = 1
                      j = i
                    end
                    i += 1
                  end
                end
                if detallefact.blank? || fact_concepto != 1
                  fecha2 = Date.parse plantilla.fechaini.to_s
                  dias = (fecha1 - fecha2).to_i + 1
                  if dias < 30
                    if fecha1.month == 2
                      valor_mens = tarifa
                    else
                      valor_dia = tarifa / 30
                      valor_mens = valor_dia * dias
                    end
                  else
                    valor_mens = tarifa
                    dias = 30
                  end
                  if concepto_id == concepto_tv.id
                    byebug
                    observacion_d = 'TELEVISION'
                    if senal.entidad.persona.condicionfisica == 'D'
                      porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
                      descuento = valor_mens * (porcentaje.to_f / 100)
                      valor_mens = valor_mens - descuento
                    end
                  elsif concepto_id == concepto_int.id
                    observacion_d = 'INTERNET'
                    doc_fact = doc_int
                  end
                  if iva_cpto > 0
                    valor_sin_iva = valor_mens / (iva_cpto / 100 + 1)
                    iva = valor_mens - valor_sin_iva
                    valor_mens = valor_sin_iva
                  end
                  if consecutivos == 'S'
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_fact};
                    SQL
                  else
                    query = <<-SQL 
                    SELECT MAX(nrofact) as ultimo FROM facturacion;
                    SQL
                  end
                  Facturacion.connection.clear_query_cache
                  ultimo = Facturacion.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo=1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  facturacion = Facturacion.new(entidad_id: senal.entidad_id, documento_id: doc_fact, fechatrn: f_elaboracion,
                    fechaven: f_fin, valor: valor_mens, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
                    estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
                  if facturacion.save
                    query = <<-SQL 
                    SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact} and documento_id = #{doc_fact};
                    SQL
                    Facturacion.connection.clear_query_cache
                    facturacion_id = Facturacion.connection.select_all(query)
                    facturacion_id = (facturacion_id[0]["id"]).to_i
                    detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
                    prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_id, cantidad: 1, 
                    valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: observacion_d + ' ' + nombre_mes,
                    operacion: '+', usuario_id: usuario_id)
                    if detallef.save
                      result = 1
                    else
                      result1 = 2
                    end
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
                    if iva > 0
                      valor_sin_iva = valor_fact / (iva / 100 + 1)
                      iva = valor_fact - valor_sin_iva
                      valor_fact = valor_sin_iva
                    end
                    query = <<-SQL 
                    UPDATE facturacion set fechaven = #{f_fin}, valor = #{valor_fact}, iva = #{iva}, dias = #{dias_fact} WHERE nrofact = #{factura[j]["nrofact"]};
                    UPDATE detalle_factura set valor = #{valor_fact}, porcentajeIva = #{iva_cpto}, iva = #{iva} WHERE nrofact = #{factura[j]["nrofact"]};
                    SQL
                    Facturacion.connection.select_all(query)
                    result = 1 
                  end
                end
              end
            end
          end
        end
      end
      if (result1 != 2)
        return respuesta = 1
      else
        return respuesta = 2
      end
    end
  end

  def self.factura_manual(tipo_facturacion, servicio_id, f_elaboracion, f_inicio, f_fin, entidad_id, valor_fact, observa, usuario_id)
    byebug
    t = Time.now
    nombre_mes = Facturacion.mes(t.strftime("%B"))
    fecha_actual = t.strftime "01/%m/%Y"
    if f_inicio <= fecha_actual
      entidad = Entidad.find(entidad_id)
      fecha1 = Date.parse f_fin
      mes = fecha1.month
      ano = fecha1.year
      concepto_tv = Concepto.find(3)
      iva_tv = concepto_tv.porcentajeIva
      concepto_int = Concepto.find(4)
      iva_int = concepto_int.porcentajeIva
      fact = 0
      doc_tv = Documento.find_by(nombre: 'FACTURA DE VENTA TELEVISION').id
      doc_int = Documento.find_by(nombre: 'FACTURA DE VENTA INTERNET').id
      serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
      serv_int = Servicio.find_by(nombre: 'INTERNET').id
      pref = Resolucion.last.prefijo
      consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
      estadoD = Estado.find_by(abreviatura: 'PE')
      
      query = <<-SQL 
      SELECT * FROM facturacion WHERE entidad_id = #{entidad_id} and fechatrn >= '01/#{mes}/#{ano}';
      SQL
      Facturacion.connection.clear_query_cache
      factura = Facturacion.connection.select_all(query)
      if servicio_id == serv_tv
        unless factura.blank?
          factura.each do |row|
            query = <<-SQL 
            SELECT * FROM detalle_factura WHERE nrofact=#{row["nrofact"]};
            SQL
            Facturacion.connection.clear_query_cache
            detallefact = Facturacion.connection.select_all(query)
            if (detallefact[0]["concepto_id"] == concepto_tv.id) 
              fact = 1
            end
          end
        end
        if fact != 1
          if consecutivos == 'S'
            query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_tv};
            SQL
          else
            query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion;
            SQL
          end
          Facturacion.connection.clear_query_cache
          ultimo = Facturacion.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo=1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          plantilla = PlantillaFact.where("entidad_id = #{entidad_id} and concepto_id = #{concepto_tv.id}")
          fecha2 = Date.parse plantilla[0]["fechaini"].to_s
          dias = (fecha1 - fecha2).to_i + 1
          if dias < 30
            if fecha1.month == 2
              dias = 30
            end
          else
            dias = 30
          end
          if entidad.persona.condicionfisica == 'D'
            porcentaje = Parametro.find_by(descripcion: 'Descuento discapacitados').valor
            descuento = valor_fact * (porcentaje.to_f / 100)
            valor_fact = valor_fact - descuento
          end
          if iva_tv > 0
            valor_sin_iva = valor_fact / (iva_tv / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc_tv, fechatrn: f_elaboracion,
            fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
            SQL
            Facturacion.connection.clear_query_cache
            facturacion_id = Facturacion.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_tv.id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_tv, iva: facturacion.iva, observacion: 'TELEVISION' + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
              return true
            else
              return false
            end
          end
        else
          return false
        end
      else
        unless factura.blank?
          factura.each do |row|
            query = <<-SQL 
            SELECT * FROM detalle_factura WHERE nrofact=#{row["nrofact"]};
            SQL
            Facturacion.connection.clear_query_cache
            detallefact = Facturacion.connection.select_all(query)
            if detallefact[0]["concepto_id"] == concepto_int.id
              fact = 1
            end
          end
        end
        if fact != 1
          if consecutivos == 'S'
            query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{doc_int};
            SQL
          else
            query = <<-SQL 
            SELECT MAX(nrofact) as ultimo FROM facturacion;
            SQL
          end
          Facturacion.connection.clear_query_cache
          ultimo = Facturacion.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo=1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          plantilla = PlantillaFact.where("entidad_id = #{entidad_id} and concepto_id = #{concepto_int.id}")
          fecha2 = Date.parse plantilla[0]["fechaini"].to_s
          dias = (fecha1 - fecha2).to_i + 1
          if dias < 30
            if fecha1.month == 2
              dias = 30
            end
          else
            dias = 30
          end
          if iva_int > 0
            valor_sin_iva = valor_fact / (iva_int / 100 + 1)
            iva = valor_fact - valor_sin_iva
            valor_fact = valor_sin_iva
          end
          facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: doc_int, fechatrn: f_elaboracion,
            fechaven: f_fin, valor: valor_fact, iva: iva, dias: dias, prefijo: pref, nrofact: ultimo,
            estado_id: estadoD.id, observacion: observa, reporta: '1', usuario_id: usuario_id)
          if facturacion.save
            query = <<-SQL 
            SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact};
            SQL
            Facturacion.connection.clear_query_cache
            facturacion_id = Facturacion.connection.select_all(query)
            facturacion_id = (facturacion_id[0]["id"]).to_i
            detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
            prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto_int.id, cantidad: 1, 
            valor: facturacion.valor, porcentajeIva: iva_int, iva: facturacion.iva, observacion: 'INTERNET' + ' ' + nombre_mes,
            operacion: '+', usuario_id: usuario_id)
            if detallef.save
              return true
            else
                return false
            end
          end
        else
          return false
        end
      end
    else
      return false
    end
  end

  def self.generar_impresion
    pdf = Prawn::Document.new
    pdf.text "Hello World"
    pdf
  end
end