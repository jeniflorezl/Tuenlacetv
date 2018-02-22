class CreatePersonas < ActiveRecord::Migration[5.1]
  def up
    create_table :personas do |t|
      t.references :tipo_documento, foreign_key: true, null:false
      t.string :documento, limit: 15, null:false
      t.varchar :nombre1, limit: 50, null:false
      t.varchar :nombre2, limit: 50
      t.varchar :apellido1, limit: 50, null:false
      t.varchar :apellido2, limit: 50
      t.string :direccion, limit: 200, null:false
      t.references :barrio, foreign_key: true, null:false
      t.references :zona, foreign_key: true, null:false
      t.string :telefono1, limit: 20
      t.string :telefono2, limit: 20
      t.string :correo, limit: 50
      t.datetime :fechanac
      t.char :tipopersona, limit: 1, null:false
      t.integer :estrato
      t.char :condicionfisica, limit: 1, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE personas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE personas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :personas
  end
end
