class CreateTraslados < ActiveRecord::Migration[5.1]
  def up
    create_table :traslados do |t|
      t.integer :orden_id, null:false
      t.references :concepto, foreign_key: true, null:false
      t.decimal :nrorden, null:false
      t.references :zonaAnt, foreign_key: { to_table: :zonas }, null:false
      t.references :barrioAnt, foreign_key: { to_table: :barrios }, null:false
      t.string :direccionAnt, limit: 200, null:false
      t.references :zonaNue, foreign_key: { to_table: :zonas }, null:false
      t.references :barrioNue, foreign_key: { to_table: :barrios }, null:false
      t.string :direccionNue, limit: 200, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE traslados 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE traslados 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE traslados
      ADD CONSTRAINT FK_traslados_ordenes
      FOREIGN KEY (orden_id,concepto_id,nrorden) REFERENCES ordenes(id,concepto_id,nrorden);
    SQL
  end

  def down
    drop_table :traslados
  end
end
