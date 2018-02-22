class CreateAbonos < ActiveRecord::Migration[5.1]
  def up
    create_table :abonos do |t|
      t.integer :pago_id, null:false
      t.references :documento, foreign_key: true, null:false
      t.decimal :nropago, null:false
      t.integer :factura_id, null:false
      t.char :prefijo, limit: 6, null:false
      t.decimal :nrofact, null:false
      t.references :concepto, foreign_key: true, null:false
      t.datetime :fechabono, null:false
      t.money :saldo, null:false
      t.money :abono, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE abonos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE abonos 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE abonos
      ADD CONSTRAINT FK_pagos
      FOREIGN KEY (pago_id,documento_id,nropago) REFERENCES pagos(id,documento_id,nropago);
    ALTER TABLE abonos
      ADD CONSTRAINT FK_facturas
      FOREIGN KEY (factura_id,prefijo,nrofact) REFERENCES facturacion(id,prefijo,nrofact);
    SQL
  end
  
  def down
    drop_table :abonos
  end
end
