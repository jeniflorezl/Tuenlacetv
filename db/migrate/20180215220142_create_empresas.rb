class CreateEmpresas < ActiveRecord::Migration[5.1]
  def up
    create_table :empresas do |t|
      t.char :tipo, limit: 2, null:false
      t.char :nit, limit: 13, null:false
      t.varchar :razonsocial, limit: 80, null:false
      t.varchar :direccion, limit: 200, null:false
      t.varchar :telefono1, limit: 20, null:false
      t.varchar :telefono2, limit: 20
      t.references :ciudad, foreign_key: true
      t.references :entidad, foreign_key: true
      t.varchar :logoempresa, limit: 100
      t.varchar :correo, limit: 50
      t.char :regimen, limit: 1
      t.char :contribuyente, limit: 1
      t.char :centrocosto, limit: 4
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
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
