class CreateBancos < ActiveRecord::Migration[5.1]
  def up
    create_table :bancos do |t|
      t.varchar :nit, limit: 13
      t.varchar :nombre, limit: 40, null:false
      t.varchar :direccion, limit: 50
      t.references :ciudad, foreign_key: true
      t.varchar :telefono1, limit: 15
      t.varchar :telefono2, limit: 15
      t.varchar :contacto, limit: 50
      t.varchar :cuentaBancaria, limit: 15
      t.varchar :cuentaContable, limit: 15
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE bancos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE bancos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :bancos
  end
end
