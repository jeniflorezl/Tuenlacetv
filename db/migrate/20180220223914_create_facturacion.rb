class CreateFacturacion < ActiveRecord::Migration[5.1]
  def up
    create_table :facturacion, {:id => false} do |t|
      t.integer :id, null:false
      t.references :entidad, foreign_key: true, null:false
      t.references :documento, foreign_key: true, null:false
      t.datetime :fechatrn, null:false
      t.datetime :fechaven, null:false
      t.money :valor, null:false
      t.money :iva, null:false
      t.integer :dias, null:false
      t.char :prefijo, limit: 6, null:false
      t.integer :nrofact, null:false
      t.references :estado, foreign_key: true, null:false
      t.string :observacion, limit: 300
      t.char :reporta, limit: 1, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE facturacion 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE facturacion 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE facturacion ADD PRIMARY KEY (id,prefijo,nrofact);
    SQL
  end

  def down
    drop_table :facturacion
  end
end
