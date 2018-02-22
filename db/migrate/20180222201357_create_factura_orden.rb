class CreateFacturaOrden < ActiveRecord::Migration[5.1]
  def up
    create_table :factura_orden do |t|
      t.integer :factura_id, null:false
      t.char :prefijo, limit: 6, null:false
      t.decimal :nrofact, null:false
      t.integer :orden_id, null:false
      t.references :concepto, foreign_key: true, null:false
      t.decimal :nrorden, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE factura_orden 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE factura_orden 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE factura_orden
      ADD CONSTRAINT FK_factorden_facturas
      FOREIGN KEY (factura_id,prefijo,nrofact) REFERENCES facturacion(id,prefijo,nrofact);
    ALTER TABLE factura_orden
      ADD CONSTRAINT FK_factorden_ordenes
      FOREIGN KEY (orden_id,concepto_id,nrorden) REFERENCES ordenes(id,concepto_id,nrorden);
    SQL
  end

  def down
    drop_table :factura_orden
  end
end
