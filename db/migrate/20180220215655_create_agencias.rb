class CreateAgencias < ActiveRecord::Migration[5.1]
  def up
    create_table :agencias do |t|
      t.references :empresa, foreign_key: true, null:false
      t.char :nit, limit: 13, null:false
      t.varchar :nombre, limit: 80, null:false
      t.string :direccion, limit: 100, null:false
      t.string :telefono1, limit: 20, null:false
      t.string :telefono2, limit: 20
      t.string :contacto, limit: 20
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE agencias 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE agencias 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :agencias
  end
end
