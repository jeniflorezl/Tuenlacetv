class CreateDetalleOrden < ActiveRecord::Migration[5.1]
  def up
    create_table :detalle_orden do |t|
      t.integer :orden_id, null:false
      t.references :concepto, foreign_key: true, null:false
      t.integer :nrorden, null:false
      t.references :articulo, foreign_key: true
      t.integer :cantidad, null:false      
      t.money :valor, null:false
      t.float :porcentajeIva, null:false
      t.money :iva, null:false
      t.money :costo, null:false
      t.string :observacion, limit: 300
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE detalle_orden 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE detalle_orden 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE detalle_orden
      ADD CONSTRAINT FK_ordenes
      FOREIGN KEY (orden_id,concepto_id,nrorden) REFERENCES ordenes(id,concepto_id,nrorden);
    SQL
  end

  def down
    drop_table :detalle_orden
  end
end
