class CreateAbonos < ActiveRecord::Migration[5.1]
  def up
    create_table :abonos do |t|
      t.integer :pago_id, null:false
      t.references :doc_pagos, foreign_key: { to_table: :documentos }, null:false
      t.integer :nropago, null:false
      t.integer :factura_id, null:false
      t.references :doc_factura, foreign_key: { to_table: :documentos }, null:false
      t.char :prefijo, limit: 6, null:false
      t.integer :nrofact, null:false
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
      FOREIGN KEY (doc_pagos_id,nropago) REFERENCES pagos(documento_id,nropago);
    ALTER TABLE abonos
      ADD CONSTRAINT FK_facturas
      FOREIGN KEY (doc_factura_id,prefijo,nrofact) REFERENCES facturacion(documento_id,prefijo,nrofact);
    SQL
  end
  
  def down
    drop_table :abonos
  end
end
