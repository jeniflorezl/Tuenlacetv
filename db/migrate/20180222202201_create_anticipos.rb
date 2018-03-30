class CreateAnticipos < ActiveRecord::Migration[5.1]
  def up
    create_table :anticipos do |t|
      t.references :entidad, foreign_key: true, null:false
      t.integer :factura_id, null:false
      t.references :doc_factura, foreign_key: { to_table: :documentos }, null:false
      t.char :prefijo, limit: 6, null:false
      t.integer :nrofact, null:false
      t.integer :pago_id, null:false
      t.references :doc_pagos, foreign_key: { to_table: :documentos }, null:false
      t.integer :nropago, null:false
      t.datetime :fechatrn, null:false
      t.datetime :fechaven, null:false
      t.money :valor, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE anticipos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE anticipos 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE anticipos
      ADD CONSTRAINT FK_anticipos_facturas
      FOREIGN KEY (doc_factura_id,prefijo,nrofact) REFERENCES facturacion(documento_id,prefijo,nrofact);
    ALTER TABLE anticipos
      ADD CONSTRAINT FK_anticipos_pagos
      FOREIGN KEY (doc_pagos_id,nropago) REFERENCES pagos(documento_id,nropago);
    SQL
  end

  def down
    drop_table :anticipos
  end
end
