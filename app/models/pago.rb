class Pago < ApplicationRecord
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :forma_pago
  belongs_to :banco
  belongs_to :usuario

  validates :entidad, :documento, :nropago, :fechatrn, :fechaven, :valor, :estado, 
  :forma_pago, :banco, :usuario, presence: true #obligatorio

  private

  def self.generar_pago(entidad_id, documento_id, fechatrn, fechaven, valor, observacion, forma_pago_id,
    banco_id, cobrador_id, detalle, usuario_id)
    query = <<-SQL 
    SELECT MAX(nropago) as ultimo FROM pagos;
    SQL
    ActiveRecord::Base.connection.clear_query_cache
    ultimo = ActiveRecord::Base.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo=1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    pago = Pago.new(entidad_id: entidad_id, documento_id: documento_id, nropago: ultimo, fechatrn: fechatrn,
      fechaven: fechaven, valor: valor, estado_id: 9, observacion: observacion, forma_pago_id: forma_pago_id,
      banco_id: banco_id, cobrador_id: cobrador_id, usuario_id: usuario_id)
      if pago.save
        query = <<-SQL 
        SELECT id FROM pagos WHERE nropago=#{pago.nropago};
        SQL
        ActiveRecord::Base.connection.clear_query_cache
        pago_id = ActiveRecord::Base.connection.select_all(query)
        pago_id = (pago_id[0]["id"]).to_i
        byebug
        detalle.each do |d|
          byebug
          query = <<-SQL 
          SELECT documento_id, prefijo, nrofact FROM facturacion WHERE id=#{d["factura_id"]};
          SQL
          ActiveRecord::Base.connection.clear_query_cache
          factura = ActiveRecord::Base.connection.select_all(query)
          abono = Abono.create(pago_id: pago_id, doc_pagos_id: pago.documento_id, nropago: pago.nropago, 
            factura_id: d["factura_id"], doc_factura_id: factura[0]["documento_id"],
            prefijo: factura[0]["prefijo"], nrofact: factura[0]["nrofact"], concepto_id: d["concepto_id"],
            fechabono: fechatrn, saldo: d["saldo"], abono: d["abono"], usuario_id: pago.usuario_id)
          if d["total"] == 0
            query = <<-SQL 
            UPDATE facturacion set estado_id = 9 WHERE id = #{d["factura_id"]};
            SQL
            ActiveRecord::Base.connection.select_all(query)
          end

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
    saldos = ActiveRecord::Base.connection.select_all(query)
    saldo_tv = saldos[0]["saldo_tv"]
    saldo_int = saldos[0]["saldo_int"]
    query = <<-SQL 
    SELECT * FROM facturacion WHERE entidad_id = #{entidad_id} ORDER BY id;
    SQL
    facturas = ActiveRecord::Base.connection.select_all(query)
    query = <<-SQL 
    SELECT * FROM pagos WHERE entidad_id = #{entidad_id};
    SQL
    pagos = ActiveRecord::Base.connection.select_all(query)
    if pagos.blank?
      facturas.reverse_each do |f|
      byebug
        dfactura = DetalleFactura.where(factura_id: f["id"])
        dfactura.reverse_each do |df|
          byebug
          concepto_id = df["concepto_id"]
          concepto = Concepto.find(concepto_id)
          detalle_facts[i] = { 'concepto' => concepto.codigo, 'desc' => concepto.nombre, 
            'nrodcto' => f["nrofact"], 'fechatrn' => f["fechatrn"], 'fechaven' => f["fechaven"],
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
            detalle_facts[i] = { 'concepto' => concepto.codigo, 'desc' => concepto.nombre, 
              'nrodcto' => f["nrofact"], 'fechatrn' => f["fechatrn"], 'fechaven' => f["fechaven"],
              'valor' => df["valor"], 'iva' => df["iva"], 'saldo' => valor_fact, 'abono' => 0,
              'total' => 0 }
          end
        end
        i += 1
        if saldo_tv == 0 && saldo_int == 0
          break
        end
      end 
    end
    detalle_facts
  end
end
