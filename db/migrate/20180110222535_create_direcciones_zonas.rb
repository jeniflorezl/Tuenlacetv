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
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE direcciones_zonas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :direcciones_zonas
  end
end
