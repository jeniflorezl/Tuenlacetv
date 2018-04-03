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

  def self.generar_pago(entidad_id, documento_id, fechatrn, valor, observacion, forma_pago_id,
    banco_id, cobrador_id, detalle, usuario_id)
    observacion = observacion.upcase!
    query = <<-SQL 
    SELECT MAX(nropago) as ultimo FROM pagos;
    SQL
    Pago.connection.clear_query_cache
    ultimo = Pago.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo=1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
      valor: valor, estado_id: 9, observacion: observacion, forma_pago_id: forma_pago_id,
      banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago=#{pago.nropago};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        byebug
        detalle.each do |d|
          byebug
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
          abono = Abono.create(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
            factura_id: factura_id[0]["factura_id"], doc_factura_id: factura[0]["documento_id"],
            prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
            fechabono: fechatrn, saldo: d["saldo"], abono: d["abono"], usuario_id: pago.usuario_id)
          if d["total"] == 0
            query = <<-SQL 
            UPDATE facturacion set estado_id = 9 WHERE id = #{factura_id[0]["factura_id"]};
            SQL
            Pago.connection.select_all(query)
          end

        end
        return true
      end
  end

  def self.generar_pago_anticipado(entidad_id, documento_id, servicio_id, fechatrn, fechapxa, cuotas, valor, observacion, forma_pago_id,
    banco_id, cobrador_id, usuario_id)
    byebug
    observacion = observacion.upcase!
    serv_tv = Servicio.find_by(nombre: 'TELEVISION').id
    serv_int = Servicio.find_by(nombre: 'INTERNET').id
    query = <<-SQL 
    SELECT saldo_tv, saldo_int FROM VwEstadoDeCuentaTotal WHERE entidad_id = #{entidad_id};
    SQL
    saldos = Pago.connection.select_all(query)
    saldo_tv = saldos[0]["saldo_tv"]
    saldo_int = saldos[0]["saldo_int"]
=begin if servicio_id == serv_tv
  if saldo_tv == 0
  end
end 
=end
    query = <<-SQL 
    SELECT MAX(nropago) as ultimo FROM pagos;
    SQL
    Pago.connection.clear_query_cache
    ultimo = Pago.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo=1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
      valor: valor, estado_id: 9, observacion: observacion, forma_pago_id: forma_pago_id,
      banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago=#{pago.nropago};
        SQL
        Pago.connection.clear_query_cache
        pago_id = Pago.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        byebug
        valor_anticipo = valor / cuotas
        fecha1 = Date.parse fechapxa
        fecha2 = fecha1 + 29
        cuotas.each do |c|
          anticipo = Anticipo.new(entidad_id: entidad_id, pago_id: pago_id, doc_pagos_id: pago.documento_id,
            nropago: pago.nropago, fechatrn: fecha1, fechaven: fecha2, valor: valor_anticipo, usuario_id: pago.usuario_id)
          fecha1 = fecha1 + 31
          fecha2 = fecha1 + 29
        end
        return true
      end
  end

  def self.detalle_facturas(entidad_id)
    byebug
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
      byebug
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          byebug
          concepto_id = df["concepto_id"]
          concepto = Concepto.find(concepto_id)
          fecha1 = Pago.formato_fecha(f["fechatrn"])
          fecha2 = Pago.formato_fecha(f["fechaven"])
          detalle_facts[i] = { 'concepto' => concepto.codigo, 'desc' => concepto.nombre, 
            'nrodcto' => f["nrofact"], 'fechatrn' => fecha1, 'fechaven' => fecha2,
            'valor' => df["valor"], 'iva' => df["iva"], 'saldo' => df["valor"] + df["iva"], 'abono' => 0,
            'total' => 0 }
          i += 1
        end
      end
    else
      byebug
      facturas.reverse_each do |f|
        byebug
        valor_fact = (f["valor"] + f["iva"]).to_i
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          byebug
          valor_df = (df["valor"] + df["iva"]).to_i
          pagos.reverse_each do |p|
            abonos = Abono.where(pago_id: p["id"])
            abonos.reverse_each do |a|
              byebug
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
            byebug
            fecha1 = Pago.formato_fecha(f["fechatrn"])
            fecha2 = Pago.formato_fecha(f["fechaven"])
            detalle_facts[i] = { 'concepto' => concepto.codigo, 'desc' => concepto.nombre, 
              'nrodcto' => f["nrofact"], 'fechatrn' => fecha1, 'fechaven' => fecha2,
              'valor' => df["valor"], 'iva' => df["iva"], 'saldo' => valor_fact, 'abono' => 0,
              'total' => 0 }
          i += 1
          end
        end
        if saldo_tv == 0 && saldo_int == 0
          break
        end
      end 
    end
    detalle_facts
  end

  def self.anular_pago(pago_id)
    query = <<-SQL 
    UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{pago_id}
    UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{pago_id}
    SQL
    Pago.connection.select_all(query)
  end

  def self.anular_pago_anticipado(pago_anticipado_id)
    ban = 0
    query = <<-SQL 
    SELECT * FROM pagos WHERE id = #{pago_anticipado_id}
    SQL
    pago = Pago.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM facturacion WHERE entidad_id = #{entidad_id}
    SQL
    facturas = Pago.connection.select_all(query)
    facturas.each do |f|
      if f["fechatrn"] == pago[0]["fechatrn"]
        ban = 1
      end
    end
    if ban == 1
      return false
    else
      query = <<-SQL 
      UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{pago_anticipado_id}
      UPDATE abonos set saldo = 0, abono = 0 WHERE pago_id = #{pago_anticipado_id}
      DELETE anticipados WHERE entidad_id = #{pago[0]["entidad_id"]} and pago_id = #{pago[0]["id"]}
      SQL
      Pago.connection.select_all(query)
    end
  end
end
