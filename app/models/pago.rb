class Pago < ApplicationRecord
  extend FormatoFecha

  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :forma_pago
  belongs_to :banco
  belongs_to :usuario

  validates :entidad, :documento, :nropago, :fechatrn, :valor, :estado, 
  :forma_pago, :banco, :usuario, presence: true #obligatorio

  private

  def self.generar_pago(entidad_id, concepto_id, fechatrn, valor, descuento, observacion, forma_pago_id,
    banco_id, cobrador_id, detalle, usuario_id)
    byebug
    ban = 0
    ban1 = 0
    abono_fact = 0
    abono_dcto = 0
    faltante = 0
    dcto = ''
    dcto_id = 0
    documento_id = 0
    observacion = observacion.upcase! unless observacion == observacion.upcase
    estado = Estado.find_by(abreviatura: 'PA').id
    case concepto_id
    when "20"
      documento_id = 2
    when "21", "22"
      documento_id = 4
    when "23", "24"
      documento_id = 5
    when "25", "26"
      documento_id = 6
    end
    query = <<-SQL 
    SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{documento_id};
    SQL
    Pago.connection.clear_query_cache
    ultimo = Pago.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo = 1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    case documento_id
    when 2, 4, 6
      valor_pago = valor + descuento
      pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
        valor: valor_pago, estado_id: estado, observacion: observacion, forma_pago_id: forma_pago_id,
        banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{documento_id};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        if descuento > 0
          detalle.each do |d|
            ban = 0
            ban1 = 0
            query = <<-SQL
            SELECT factura_id FROM detalle_factura WHERE nrofact = #{d["nrodcto"]};
            SQL
            Pago.connection.clear_query_cache
            factura_id = Pago.connection.select_all(query)
            query = <<-SQL 
            SELECT documento_id, prefijo, nrofact FROM facturacion WHERE id = #{factura_id[0]["factura_id"]};
            SQL
            Pago.connection.clear_query_cache
            factura = Pago.connection.select_all(query)
            if valor >= d["saldo"]
              abono_fact = d["saldo"]
              ban = 1
            else
              ban = 2
              abono_fact = valor
              faltante = d["saldo"] - abono_fact
              if faltante >= descuento
                abono_dcto = descuento
              else
                abono_dcto = faltante
              end
            end
            valor = valor - abono_fact
            descuento = descuento - abono_dcto
            if ban == 1
              abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
                prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
                fechabono: fechatrn, saldo: d["saldo"], abono: abono_fact, usuario_id: pago.usuario_id)
              unless abono.save
                return false
              end
            elsif ban == 2
              doc_dcto = Documento.find_by(nombre: 'DESCUENTOS').id
              if dcto.blank?
                ban1 = 1
              else
                ban1 = 2
              end
              if ban1 == 1
                if abono_fact > 0
                  abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
                    factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
                    prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
                    fechabono: fechatrn, saldo: d["saldo"], abono: abono_fact, usuario_id: pago.usuario_id)
                  unless abono.save
                    return false
                  end
                end
                if abono_dcto > 0
                  query = <<-SQL 
                  SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_dcto};
                  SQL
                  Pago.connection.clear_query_cache
                  ultimo = Pago.connection.select_all(query)
                  if ultimo[0]["ultimo"] == nil
                    ultimo = 1
                  else
                    ultimo = (ultimo[0]["ultimo"]).to_i + 1
                  end
                  dcto = Pago.new(entidad_id: entidad_id, documento_id: doc_dcto, nropago: ultimo, fechatrn: fechatrn,
                    valor: abono_dcto, estado_id: estado, observacion: 'DESCUENTO', forma_pago_id: forma_pago_id,
                    banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
                  if dcto.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago = #{dcto.nropago} and documento_id = #{doc_dcto};
                    SQL
                    Pago.connection.clear_query_cache
                    dcto_id = Pago.connection.select_all(query)
                    dcto_id = (dcto_id[0]["id"]).to_i
                  else
                    return false
                  end
                end
              elsif ban1 == 2
                query = <<-SQL 
                UPDATE pagos set valor = valor + #{abono_dcto} WHERE id = #{dcto_id};
                SQL
                Pago.connection.select_all(query)
              end
              abono = Abono.new(pago_id: dcto_id, doc_pagos_id: dcto.documento_id, nropago: dcto.nropago, 
                factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
                prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
                fechabono: fechatrn, saldo: faltante, abono: abono_dcto, usuario_id: pago.usuario_id)
              if abono.save
                descuento_pago = Descuento.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago,
                  dcto_id: dcto_id, doc_dctos_id: dcto.documento_id, nrodcto: dcto.nropago, usuario_id: usuario_id)
                unless descuento_pago.save
                  return false
                end
              else
                return false
              end
            end
            if d["total"] == 0
              query = <<-SQL 
              UPDATE facturacion set estado_id = #{estado} WHERE id = #{factura_id[0]["factura_id"]};
              SQL
              Pago.connection.select_all(query)
            end
          end
        else
          detalle.each do |d|
            query = <<-SQL 
            SELECT factura_id FROM detalle_factura WHERE nrofact = #{d["nrodcto"]};
            SQL
            Pago.connection.clear_query_cache
            factura_id = Pago.connection.select_all(query)
            query = <<-SQL 
            SELECT documento_id, prefijo, nrofact FROM facturacion WHERE id = #{factura_id[0]["factura_id"]};
            SQL
            Pago.connection.clear_query_cache
            factura = Pago.connection.select_all(query)
            abono = Abono.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
              factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
              prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
              fechabono: fechatrn, saldo: d["saldo"], abono: d["abono"], usuario_id: pago.usuario_id)
            unless abono.save
              return false
            end
            if d["total"] == 0
              query = <<-SQL 
              UPDATE facturacion set estado_id = #{estado} WHERE id = #{factura_id[0]["factura_id"]};
              SQL
              Pago.connection.select_all(query)
            end
          end
        end
        return true
      else
        return false
      end
    else
      estado = Estado.find_by(abreviatura: 'PE').id
      pref = Resolucion.last.prefijo
      fecha_fact = fechatrn.split("/")
      fecha_fact = Time.new(fecha_fact[2], fecha_fact[1], fecha_fact[0])
      nombre_mes = Facturacion.mes(fecha_fact.strftime("%B"))
      concepto = Concepto.find(concepto_id)
      iva_cpto = concepto.porcentajeIva
      query = <<-SQL 
      SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id = #{documento_id};
      SQL
      Pago.connection.clear_query_cache
      ultimo = Pago.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo = 1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      if iva_cpto > 0
        valor_sin_iva = valor / (iva_cpto / 100 + 1)
        iva = valor - valor_sin_iva
        valor = valor_sin_iva
      end
      facturacion = Facturacion.new(entidad_id: entidad_id, documento_id: documento_id, fechatrn: fechatrn,
        fechaven: fechatrn, valor: valor, iva: iva, dias: 0, prefijo: pref, nrofact: ultimo,
        estado_id: estado, observacion: observacion, reporta: '1', usuario_id: usuario_id)
      if facturacion.save
        query = <<-SQL 
        SELECT id FROM facturacion WHERE nrofact = #{facturacion.nrofact} and documento_id = #{documento_id};
        SQL
        Pago.connection.clear_query_cache
        facturacion_id = Pago.connection.select_all(query)
        facturacion_id = (facturacion_id[0]["id"]).to_i
        detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_cpto, iva: facturacion.iva, observacion: facturacion.observacion,
          operacion: '+', usuario_id: usuario_id)
        if detallef.save
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end

  def self.generar_pago_anticipado(entidad_id, documento_id, servicio_id, fechatrn, fechapxa, valor, descuento, observacion, forma_pago_id,
    banco_id, cobrador_id, usuario_id)
    byebug
    ban = 0
    ban1 = 0
    resp = 0
    concepto = 0
    valor_abono = 0
    estado = Estado.find_by(abreviatura: 'PE').id
    observacion = observacion.upcase! unless observacion == observacion.upcase
    serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
    serv_int = Servicio.find_by(nombre: 'INTERNET').id
    query = <<-SQL 
    SELECT saldo_tv, saldo_int FROM VwEstadoDeCuentaTotal WHERE entidad_id = #{entidad_id};
    SQL
    Pago.connection.clear_query_cache
    saldos = Pago.connection.select_all(query)
    saldo_tv = saldos[0]["saldo_tv"]
    saldo_int = saldos[0]["saldo_int"]
    if servicio_id == serv_tv.to_s
      if saldo_tv == 0
        ban = 1
        concepto = 3
      end
    else
      if saldo_int == 0
        ban = 1
        concepto = 4
      end
    end
    if ban == 1
      query = <<-SQL 
      SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{documento_id};
      SQL
      Pago.connection.clear_query_cache
      ultimo = Pago.connection.select_all(query)
      if ultimo[0]["ultimo"] == nil
        ultimo = 1
      else
        ultimo = (ultimo[0]["ultimo"]).to_i + 1
      end
      valor_total = valor + descuento
      pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
        valor: valor_total, estado_id: estado, observacion: observacion, forma_pago_id: forma_pago_id,
        banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago = #{pago.nropago} and documento_id = #{documento_id};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        plantilla = PlantillaFact.find_by(entidad_id: entidad_id, concepto_id: concepto)
        tarifa = Tarifa.find(plantilla.tarifa_id).valor
        fecha1 = Date.parse fechapxa
        fecha2 = fecha1 + 29
        if descuento > 0
          doc_dcto = Documento.find_by(nombre: 'DESCUENTOS').id
          query = <<-SQL 
          SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id = #{doc_dcto};
          SQL
          Pago.connection.clear_query_cache
          ultimo = Pago.connection.select_all(query)
          if ultimo[0]["ultimo"] == nil
            ultimo = 1
          else
            ultimo = (ultimo[0]["ultimo"]).to_i + 1
          end
          dcto = Pago.new(entidad_id: entidad_id, documento_id: doc_dcto, nropago: ultimo, fechatrn: fechatrn,
            valor: descuento, estado_id: estado, observacion: 'DESCUENTO', forma_pago_id: forma_pago_id,
            banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
          if dcto.save
            query = <<-SQL 
            SELECT id FROM pagos WHERE nropago = #{dcto.nropago} and documento_id = #{doc_dcto};
            SQL
            Pago.connection.clear_query_cache
            dcto_id = Pago.connection.select_all(query)
            dcto_id = (dcto_id[0]["id"]).to_i
            descuento_pago = Descuento.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago,
              dcto_id: dcto_id, doc_dctos_id: dcto.documento_id, nrodcto: dcto.nropago, usuario_id: usuario_id)
            unless descuento_pago.save
              return resp = 2
            end
          else
            return resp = 2
          end
        end
        while valor > 0
          if valor >= tarifa
            valor_abono = tarifa
          else
            valor_abono = valor
          end
          anticipo = Anticipo.new(entidad_id: entidad_id, servicio_id: servicio_id, pago_id: pago_id, doc_pagos_id: pago.documento_id,
            nropago: pago.nropago, fechatrn: fecha1, fechaven: fecha2, valor: valor_abono, usuario_id: pago.usuario_id)
          unless anticipo.save
            return resp = 2
          end
          valor = valor - valor_abono
          fecha1 = fecha1 + 30
          if fecha1.day == 31
            fecha1 = fecha1 + 1
          end
          fecha2 = fecha1 + 29
        end
        while descuento > 0
          dcto_anticipo = Anticipo.where(pago_id: pago_id).last
          if dcto_anticipo.valor < tarifa
            faltante = tarifa - dcto_anticipo.valor
            if descuento >= faltante
              valor_abono = faltante
            else
              valor_abono = descuento
            end
            ban1 = 1
          else
            if descuento >= tarifa
              valor_abono = tarifa
            else
              valor_abono = descuento
            end
          end
          if ban1 == 1
            query = <<-SQL 
            UPDATE anticipos set valor = valor + #{valor_abono} WHERE id = #{dcto_anticipo.id};
            SQL
            Pago.connection.select_all(query)
          else
            anticipo = Anticipo.new(entidad_id: entidad_id, servicio_id: servicio_id, pago_id: dcto_id, doc_pagos_id: dcto.documento_id,
              nropago: dcto.nropago, fechatrn: fecha1, fechaven: fecha2, valor: valor_abono, usuario_id: dcto.usuario_id)
            unless anticipo.save
              return resp = 2
            end
          end
          descuento = descuento - valor_abono
          fecha1 = fecha1 + 30
          if fecha1.day == 31
            fecha1 = fecha1 + 1
          end
          fecha2 = fecha1 + 29
        end
        return resp = 1
      else
        return resp = 2
      end
    else
      return resp = 3
    end
  end

  def self.detalle_facturas(entidad_id)
    detalle_facts = Array.new
    i = 0
    ban = 0
    query = <<-SQL 
    SELECT saldo_tv, saldo_int FROM VwEstadoDeCuentaTotal WHERE entidad_id = #{entidad_id};
    SQL
    saldos = Pago.connection.select_all(query)
    saldo_tv = saldos[0]["saldo_tv"]
    saldo_int = saldos[0]["saldo_int"]
    estado = Estado.find_by(abreviatura: 'AN').id
    query = <<-SQL 
    SELECT * FROM facturacion WHERE entidad_id = #{entidad_id} and estado_id <> #{estado} ORDER BY id;
    SQL
    facturas = Pago.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM pagos WHERE entidad_id = #{entidad_id} and estado_id <> #{estado} ORDER BY id;
    SQL
    pagos = Pago.connection.select_all(query)
    if pagos.blank?
      facturas.reverse_each do |f|
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          concepto_id = df["concepto_id"]
          concepto = Concepto.find(concepto_id)
          fecha1 = Pago.formato_fecha(f["fechatrn"])
          fecha2 = Pago.formato_fecha(f["fechaven"])
          detalle_facts[i] = { 'concepto_id' => concepto.id, 'concepto' => concepto.codigo, 
            'desc' => concepto.nombre, 'nrodcto' => f["nrofact"], 'fechatrn' => fecha1, 
            'fechaven' => fecha2, 'valor' => (df["valor"].to_f).round, 'iva' => (df["iva"].to_f).round, 
            'saldo' => (df["valor"].to_f).round + (df["iva"].to_f).round, 'abono' => 0, 'total' => 0 }
          i += 1
        end
      end
    else
      facturas.reverse_each do |f|
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          valor_df = (df["valor"] + df["iva"]).to_i
          pagos.reverse_each do |p|
            abonos = Abono.where(pago_id: p["id"])
            abonos.reverse_each do |a|
              if f["id"] == a["factura_id"] && df["concepto_id"] == a["concepto_id"]
                valor_df = valor_df - a["abono"].to_i
              end
            end
            anticipos = Anticipo.where(pago_id: p["id"])
            anticipos.reverse_each do |ant|
              if ant["servicio_id"] == 1
                concepto = 3
              else
                concepto = 4
              end
              if f["id"] == ant["factura_id"] && df["concepto_id"] == concepto
                valor_df = valor_df - ant["valor"].to_i
              end
            end
          end
          if valor_df != 0
            concepto_id = df["concepto_id"]
            concepto = Concepto.find(concepto_id)
            servicio_id = concepto.servicio_id
            if  servicio_id == 1
              saldo_tv = saldo_tv - valor_df
            else
              saldo_int = saldo_int - valor_df
            end
            fecha1 = Pago.formato_fecha(f["fechatrn"])
            fecha2 = Pago.formato_fecha(f["fechaven"])
            detalle_facts[i] = { 'concepto_id' => concepto.id, 'concepto' => concepto.codigo, 
              'desc' => concepto.nombre, 'nrodcto' => f["nrofact"], 'fechatrn' => fecha1, 
              'fechaven' => fecha2, 'valor' => (df["valor"].to_f).round, 'iva' => (df["iva"].to_f).round, 
              'saldo' => valor_df, 'abono' => 0, 'total' => 0 }
          i += 1
          end
        end
        if saldo_tv == 0 && saldo_int == 0
          break
        end
      end 
    end
    detalle_facts = detalle_facts.reverse
    detalle_facts
  end

  def self.valor_total(detalle_facts)
    valor_total = 0
    detalle_facts.each do |d|
      valor_total = valor_total + d["saldo"]
    end
    valor_total
  end

  def self.observacion_pago(detalle_facts)
    ordenado = detalle_facts.sort_by { |hsh| hsh[:fechatrn] }
    fecha_observa = ordenado.last["fechatrn"]
    fecha_observa = fecha_observa.split("/")
    f_fact = Time.new(fecha_observa[2], fecha_observa[1], fecha_observa[0])
    nombre_mes = Facturacion.mes(f_fact.strftime("%B"))
    observacion = 'PAGA HASTA ' + nombre_mes
  end

  def self.anular_pago(pago_id)
    estado = Estado.find_by(abreviatura: 'AN').id
    dctos = Descuento.where(pago_id: pago_id)
    query = <<-SQL 
    UPDATE pagos set valor = 0, estado_id = #{estado}, observacion = 'ANULADO' WHERE id = #{pago_id}
    UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{pago_id}
    SQL
    Pago.connection.select_all(query)
    unless dctos.blank?
      dctos.each do |dcto|
        query = <<-SQL 
        UPDATE pagos set valor = 0, estado_id = #{estado}, observacion = 'ANULADO' WHERE id = #{dcto.dcto_id}
        UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{dcto.dcto_id}
        SQL
        Pago.connection.select_all(query)
      end
    end
    return true
  end

  def self.anular_pago_anticipado(pago_anticipado)
    byebug
    ban = 0
    estado = Estado.find_by(abreviatura: 'AN').id
    query = <<-SQL 
    SELECT * FROM anticipos WHERE pago_id = #{pago_anticipado[0]["id"]}
    SQL
    pag_anticipado = Pago.connection.select_all(query)
    pag_anticipado.each do |p_ant|
      byebug
      fechapxa = Date.parse p_ant["fechatrn"].to_s
      query = <<-SQL 
      SELECT * FROM facturacion WHERE year(fechatrn) = #{fechapxa.year} and month(fechatrn) = #{fechapxa.month} and entidad_id = #{pago_anticipado[0]["entidad_id"]};
      SQL
      factura = Pago.connection.select_all(query)
      unless factura.blank?
        ban = 1
        break
      end
    end
    if ban == 1
      return false
    else
      query = <<-SQL 
      UPDATE pagos set valor = 0, estado_id = #{estado}, observacion = 'ANULADO' WHERE id = #{pago_anticipado[0]["id"]}
      DELETE anticipos WHERE entidad_id = #{pago_anticipado[0]["entidad_id"]} and pago_id = #{pago_anticipado[0]["id"]}
      SQL
      Pago.connection.select_all(query)
      dctos = Descuento.where(pago_id: pago_anticipado[0]["id"])
      unless dctos.blank?
        dctos.each do |dcto|
          query = <<-SQL 
          UPDATE pagos set valor = 0, estado_id = #{estado}, observacion = 'ANULADO' WHERE id = #{dcto.dcto_id}
          DELETE anticipos WHERE entidad_id = #{pago_anticipado[0]["entidad_id"]} and pago_id = #{dcto.dcto_id}
          SQL
          Pago.connection.select_all(query)
        end
      end
      return true
    end
  end

  def self.detallle_recibos(f_ini, f_fin)
    recibos = Array.new
    dcto = 0
    fechaini = Date.parse f_ini.to_s
    fechafin = Date.parse f_fin.to_s
    query = <<-SQL 
    SELECT * FROM pagos WHERE fechatrn >= '#{fechaini}' and fechatrn <= '#{fechafin}' ORDER BY nropago;
    SQL
    pagos = Facturacion.connection.select_all(query)
    entidades = Entidad.all
    i = 0
    pagos.each do |p|
      entidad = Entidad.find(p["entidad_id"])
      fecha = (p["fechatrn"].to_s).split(' ')
      fecha1 = fecha[0].split('-')
      fecha_time = Time.new(fecha1[0], fecha1[1], fecha1[2])
      f_mes = fecha_time.strftime("%m")
      f_ano = fecha_time.strftime("%Y")
      if entidad.persona.nombre2.blank?
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      else
        nombres = entidad.persona.nombre1 + ' ' + entidad.persona.nombre2 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
      end
      descuento = Descuento.find_by(pago_id: p["id"])
      dcto = (descuento.valor.to_f).round unless descuento.blank?
      abonos = Abono.where(pago_id: p["id"])
      if abonos.blank?
        anticipos = Anticipo.where("pago_id = #{p["id"]} and month(fechatrn) = #{f_mes} and year(fechatrn) = #{f_ano}")
        anticipos.each do |ant|
          recibos[i] = { 'entidad_id' => p["entidad_id"], 'nombres' => nombres, 
            'valor' => (ant["valor"].to_f).round, 'descuento' => dcto, 
            'total' => (ant["valor"].to_f).round + dcto, 'nrorecibo' => p["nropago"], 
            'mes' => f_mes, 'nrofact' => ant["nrofact"], 'observacion' => p["observacion"] }
          i += 1
        end
      else
        abonos.each do |a|
          recibos[i] = { 'entidad_id' => p["entidad_id"], 'nombres' => nombres, 
            'valor' => (a["abono"].to_f).round, 'descuento' => dcto, 
            'total' => (a["abono"].to_f).round + dcto, 'nrorecibo' => p["nropago"], 
            'mes' => f_mes, 'nrofact' => a["nrofact"], 'observacion' => p["observacion"] }
          i += 1
        end
      end
    end
    recibos
  end
end
