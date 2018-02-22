class CreateEmpresas < ActiveRecord::Migration[5.1]
  def up
    create_table :empresas do |t|
      t.char :tipo, limit: 2, null:false
      t.char :nit, limit: 13, null:false
      t.varchar :razonsocial, limit: 80, null:false
      t.string :direccion, limit: 200, null:false
      t.string :telefono1, limit: 20, null:false
      t.string :telefono2, limit: 20
      t.references :ciudad, foreign_key: true, null:false
      t.references :entidad, foreign_key: true, null:false
      t.string :logo, limit: 100
      t.string :correo, limit: 50
      t.char :regimen, limit: 1
      t.char :contribuyente, limit: 1
      t.char :centrocosto, limit: 4
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE empresas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE empresas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :empresas
  end
end
