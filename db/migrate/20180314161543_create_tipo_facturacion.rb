class CreateTipoFacturacion < ActiveRecord::Migration[5.1]
  def up
    create_table :tipo_facturacion do |t|
      t.varchar :nombre, limit: 30, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE tipo_facturacion 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tipo_facturacion 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :tipo_facturacion
  end
end
