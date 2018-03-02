class CreateResoluciones < ActiveRecord::Migration[5.1]
  def up
    create_table :resoluciones do |t|
      t.references :empresa, foreign_key: true, null:false
      t.string :nroResolucion, limit:20, null:false
      t.string :tipo, limit:20, null:false
      t.string :prefijo, limit:4, null:false
      t.string :rangoRI, limit:20, null:false
      t.string :rangoRF, limit:20, null:false
      t.integer :rangoI, null:false
      t.integer :rangoF, null:false
      t.datetime :fechainicio, null:false
      t.datetime :fechavence, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE resoluciones 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE resoluciones 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :resoluciones
  end
end
