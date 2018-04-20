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

  def self.generar_pago(entidad_id, documento_id, fechatrn, valor, descuento, observacion, forma_pago_id,
    banco_id, cobrador_id, detalle, usuario_id)
    ban = 0
    ban1 = 0
    abono_fact = 0
    abono_dcto = 0
    faltante = 0
    dcto = ''
    dcto_id = 0
    serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
    serv_int = Servicio.find_by(nombre: 'INTERNET').id
    observacion = observacion.upcase! unless observacion == observacion.upcase
    estado = Estado.find_by(abreviatura: 'PA').id
    consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
    if consecutivos == 'S'
      query = <<-SQL 
      SELECT MAX(nropago) as ultimo FROM pagos WHERE documento_id=#{documento_id};
      SQL
    else
      query = <<-SQL 
      SELECT MAX(nropago) as ultimo FROM pagos;
      SQL
    end
    Pago.connection.clear_query_cache
    ultimo = Pago.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo = 1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    case documento_id
    when "3", "5", "6", "9", "10"
      valor_pago = valor + descuento
      pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
        valor: valor_pago, estado_id: estado, observacion: observacion, forma_pago_id: forma_pago_id,
        banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago=#{pago.nropago};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        if descuento > 0
          detalle.each do |d|
            ban = 0
            ban1 = 0
            query = <<-SQL 
            SELECT factura_id FROM detalle_factura WHERE nrofact=#{d["nrodcto"]};
            SQL
            Pago.connection.clear_query_cache
            factura_id = Pago.connection.select_all(query)
            query = <<-SQL 
            SELECT documento_id, prefijo, nrofact FROM facturacion WHERE id=#{factura_id[0]["factura_id"]};
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
              serv = Concepto.find(d["concepto_id"]).servicio_id
              if serv == serv_tv
                doc_dcto = Documento.find_by(nombre: 'DESCUENTOS TELEVISION').id
              else
                doc_dcto = Documento.find_by(nombre: 'DESCUENTOS INTERNET').id
              end
              if dcto.blank?
                ban1 = 1
              elsif dcto.documento_id == doc_dcto
                ban1 = 2
              else
                ban1 = 3
              end
              if ban1 == 3
                dcto_pago = Descuento.where(pago_id: pago_id)
                dcto_pago.each do |dcto_p|
                  if dcto_p.doc_dctos_id == doc_dcto
                    dcto_id = dcto_p.dcto_id
                    dcto = dcto_p
                    ban1 = 4
                    break
                  else
                    ban1 = 5
                  end
                end
              end
              if ban1 == 1 || ban1 == 5
                query = <<-SQL 
                SELECT MAX(nropago) as ultimo FROM pagos;
                SQL
                Pago.connection.clear_query_cache
                ultimo = Pago.connection.select_all(query)
                if ultimo[0]["ultimo"] == nil
                  ultimo = 1
                else
                  ultimo = (ultimo[0]["ultimo"]).to_i + 1
                end
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
                  dcto = Pago.new(entidad_id: entidad_id, documento_id: doc_dcto, nropago: ultimo, fechatrn: fechatrn,
                    valor: abono_dcto, estado_id: estado, observacion: 'DESCUENTO', forma_pago_id: forma_pago_id,
                    banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
                  if dcto.save
                    query = <<-SQL 
                    SELECT id FROM pagos WHERE nropago=#{dcto.nropago};
                    SQL
                    Pago.connection.clear_query_cache
                    dcto_id = Pago.connection.select_all(query)
                    dcto_id = (dcto_id[0]["id"]).to_i
                  else
                    return false
                  end
                end
              elsif ban1 == 2 || ban1 == 4
                query = <<-SQL 
                UPDATE pagos set valor = valor + #{abono_dcto} WHERE id = #{dcto_id};
                SQL
                Pago.connection.select_all(query)
              end
              if ban1 == 4
                abono = Abono.new(pago_id: dcto_id, doc_pagos_id: dcto.doc_dctos_id, nropago: dcto.nrodcto, 
                  factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
                  prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
                  fechabono: fechatrn, saldo: faltante, abono: abono_dcto, usuario_id: pago.usuario_id)
                if abono.save
                  descuento_pago = Descuento.new(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago,
                    dcto_id: dcto_id, doc_dctos_id: dcto.doc_dctos_id, nrodcto: dcto.nrodcto, usuario_id: usuario_id)
                  unless descuento_pago.save
                    return false
                  end
                else
                  return false
                end
              else
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
            end
            if d["total"] == 0
              query = <<-SQL 
              UPDATE facturacion set estado_id = 9 WHERE id = #{factura_id[0]["factura_id"]};
              SQL
              Pago.connection.select_all(query)
            end
          end
        else
          detalle.each do |d|
            query = <<-SQL 
            SELECT factura_id FROM detalle_factura WHERE nrofact=#{d["nrodcto"]};
            SQL
            Pago.connection.clear_query_cache
            factura_id = Pago.connection.select_all(query)
            query = <<-SQL 
            SELECT documento_id, prefijo, nrofact FROM facturacion WHERE id=#{factura_id[0]["factura_id"]};
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
              UPDATE facturacion set estado_id = 9 WHERE id = #{factura_id[0]["factura_id"]};
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
      if documento_id == "7"
        concepto = Concepto.find(3)
        iva_cpto = concepto.porcentajeIva
        observacion_d = 'TELEVISION'
      else
        concepto = Concepto.find(4)
        iva_cpto = concepto.porcentajeIva
        observacion_d = 'INTERNET'
      end
      if consecutivos == 'S'
        query = <<-SQL 
        SELECT MAX(nrofact) as ultimo FROM facturacion WHERE documento_id=#{documento_id};
        SQL
      else
        query = <<-SQL 
        SELECT MAX(nrofact) as ultimo FROM facturacion;
        SQL
      end
      Facturacion.connection.clear_query_cache
      ultimo = Facturacion.connection.select_all(query)
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
        SELECT id FROM facturacion WHERE nrofact=#{facturacion.nrofact} and documento_id = #{documento_id};
        SQL
        Facturacion.connection.clear_query_cache
        facturacion_id = Facturacion.connection.select_all(query)
        facturacion_id = (facturacion_id[0]["id"]).to_i
        detallef = DetalleFactura.new(factura_id: facturacion_id, documento_id: facturacion.documento_id, 
          prefijo: facturacion.prefijo, nrofact: facturacion.nrofact, concepto_id: concepto.id, cantidad: 1, 
          valor: facturacion.valor, porcentajeIva: iva_cpto, iva: facturacion.iva, observacion: observacion_d + ' ' + nombre_mes,
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
      SELECT MAX(nropago) as ultimo FROM pagos;
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
        SELECT id FROM pagos WHERE nropago=#{pago.nropago};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        plantilla = PlantillaFact.where("concepto_id = #{concepto} and entidad_id = #{entidad_id}")
        tarifa = Tarifa.find(plantilla[0]["tarifa_id"]).valor
        fecha1 = Date.parse fechapxa
        fecha2 = fecha1 + 29
        if descuento > 0
          if servicio_id == serv_tv.to_s
            doc_dcto = Documento.find_by(nombre: 'DESCUENTOS TELEVISION').id
          else
            doc_dcto = Documento.find_by(nombre: 'DESCUENTOS INTERNET').id
          end
          query = <<-SQL 
          SELECT MAX(nropago) as ultimo FROM pagos;
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
            SELECT id FROM pagos WHERE nropago=#{dcto.nropago};
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
    query = <<-SQL 
    SELECT * FROM facturacion WHERE entidad_id = #{entidad_id} and estado_id <> 7 ORDER BY id;
    SQL
    facturas = Pago.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM pagos WHERE entidad_id = #{entidad_id};
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
        valor_fact = ((f["valor"].to_f).round + (f["iva"].to_f).round)
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          valor_df = (df["valor"] + df["iva"]).to_i
          pagos.reverse_each do |p|
            abonos = Abono.where(pago_id: p["id"])
            abonos.reverse_each do |a|
              if f["id"] == a["factura_id"] && df["concepto_id"] == a["concepto_id"]
                valor_fact = valor_fact - a["abono"].to_i
                valor_df = valor_df - a["abono"].to_i
              end
            end
          end
          if valor_fact != 0 
            concepto_id = df["concepto_id"]
            concepto = Concepto.find(concepto_id)
            servicio_id = concepto.servicio_id
            if  servicio_id == 1
              saldo_tv = saldo_tv - valor_fact
            else
              saldo_int = saldo_int - valor_fact
            end
          end
          if valor_df != 0
            fecha1 = Pago.formato_fecha(f["fechatrn"])
            fecha2 = Pago.formato_fecha(f["fechaven"])
            detalle_facts[i] = { 'concepto_id' => concepto.id, 'concepto' => concepto.codigo, 
              'desc' => concepto.nombre, 'nrodcto' => f["nrofact"], 'fechatrn' => fecha1, 
              'fechaven' => fecha2, 'valor' => (df["valor"].to_f).round, 'iva' => (df["iva"].to_f).round, 
              'saldo' => valor_fact, 'abono' => 0, 'total' => 0 }
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

  def self.anular_pago(pago_id)
    dctos = Descuento.where(pago_id: pago_id)
    query = <<-SQL 
    UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{pago_id}
    UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{pago_id}
    SQL
    Pago.connection.select_all(query)
    unless dctos.blank?
      dctos.each do |dcto|
        query = <<-SQL 
        UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{dcto.dcto_id}
        UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{dcto.dcto_id}
        SQL
        Pago.connection.select_all(query)
      end
    end
    return true
  end

  def self.anular_pago_anticipado(pago_anticipado)
    ban = 0
    query = <<-SQL 
    SELECT * FROM anticipos WHERE pago_id = #{pago_anticipado[0]["id"]}
    SQL
    pag_anticipado = Pago.connection.select_all(query)
    pag_anticipado.each do |p_ant|
      fechapxa = Date.parse p_ant["fechatrn"].to_s
      query = <<-SQL 
      SELECT * FROM facturacion WHERE (SELECT DATEPART(year, fechatrn)) = #{fechapxa.year} and (SELECT DATEPART(month, fechatrn)) = #{fechapxa.month}
      SQL
      factura = Pago.connection.select_all(query)
      if factura.blank?
        ban == 1
      end
    end
    if ban == 1
      return false
    else
      query = <<-SQL 
      UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{pago_anticipado[0]["id"]}
      DELETE anticipos WHERE entidad_id = #{pago_anticipado[0]["entidad_id"]} and pago_id = #{pago_anticipado[0]["id"]}
      SQL
      Pago.connection.select_all(query)
      dctos = Descuento.where(pago_id: pago_anticipado[0]["id"])
      unless dctos.blank?
        dctos.each do |dcto|
          query = <<-SQL 
          UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{dcto.dcto_id}
          DELETE anticipos WHERE entidad_id = #{pago_anticipado[0]["entidad_id"]} and pago_id = #{dcto.dcto_id}
          SQL
          Pago.connection.select_all(query)
        end
      end
    end
  end
end
