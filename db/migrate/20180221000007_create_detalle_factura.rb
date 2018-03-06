class CreateDetalleFactura < ActiveRecord::Migration[5.1]
  def up
    create_table :detalle_factura do |t|
      t.integer :factura_id, null:false
      t.references :documento, foreign_key: true, null:false
      t.char :prefijo, limit: 6, null:false
      t.integer :nrofact, null:false
      t.references :concepto, foreign_key: true, null:false
      t.integer :cantidad, limit: 3, null:false      
      t.money :valor, null:false
      t.float :porcentajeIva, null:false
      t.money :iva, null:false
      t.string :observacion, limit: 300
      t.char :operacion, limit: 1, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE detalle_factura 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE detalle_factura 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE detalle_factura
      ADD CONSTRAINT FK_facturacion
      FOREIGN KEY (documento_id,prefijo,nrofact) REFERENCES facturacion(documento_id,prefijo,nrofact);
    SQL
  end

  def down
    drop_table :detalle_factura
  end
end
