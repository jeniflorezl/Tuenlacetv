class CreatePersonas < ActiveRecord::Migration[5.1]
  def up
    create_table :personas do |t|
      t.references :tipo_documento, foreign_key: true
      t.varchar :documento, limit: 15, null:false
      t.varchar :nombre1, limit: 50, null:false
      t.varchar :nombre2, limit: 50
      t.varchar :apellido1, limit: 50, null:false
      t.varchar :apellido2, limit: 50
      t.varchar :direccion, limit: 200
      t.varchar :telefono1, limit: 20
      t.varchar :telefono2, limit: 20
      t.references :barrio, foreign_key: true
      t.references :zona, foreign_key: true
      t.varchar :correo, limit: 50
      t.datetime :fechanac
      t.char :tipopersona, limit: 1, null:false
      t.integer :estrato
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
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
