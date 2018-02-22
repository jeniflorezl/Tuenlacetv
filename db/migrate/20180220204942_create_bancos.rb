class CreateBancos < ActiveRecord::Migration[5.1]
  def up
    create_table :bancos do |t|
      t.string :nit, limit: 13
      t.varchar :nombre, limit: 40, null:false
      t.string :direccion, limit: 50
      t.references :ciudad, foreign_key: true, null:false
      t.string :telefono1, limit: 15
      t.string :telefono2, limit: 15
      t.string :contacto, limit: 50
      t.string :cuentaBancaria, limit: 15
      t.string :cuentaContable, limit: 15
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
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
