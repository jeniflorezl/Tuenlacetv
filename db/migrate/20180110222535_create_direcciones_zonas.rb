class CreateDireccionesZonas < ActiveRecord::Migration[5.1]
  def up
    create_table :direcciones_zonas do |t|
      t.references :zona, foreign_key: true
      t.varchar :direccion, limit: 100, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE direcciones_zonas
      ADD CONSTRAINT DF_direcciones_zonas_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE direcciones_zonas
      ADD CONSTRAINT DF_direcciones_zonas_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE direcciones_zonas
      DROP CONSTRAINT DF_direcciones_zonas_fechacre
    ALTER TABLE direcciones_zonas
      DROP CONSTRAINT DF_direcciones_zonas_fechacam
    SQL
    drop_table :direcciones_zonas
  end
end
