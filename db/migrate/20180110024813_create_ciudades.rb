class CreateCiudades < ActiveRecord::Migration[5.1]
  def up
    create_table :ciudades do |t|
      t.references :pais, foreign_key: true
      t.varchar :nombre, limit: 80, null:false
      t.char :codigoDane, limit: 5
      t.char :codigoAlterno, limit: 5
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE ciudades 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE ciudades 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :ciudades
  end
end
