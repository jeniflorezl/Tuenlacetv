class CreateArticulos < ActiveRecord::Migration[5.1]
  def up
    create_table :articulos do |t|
      t.references :grupo, foreign_key: true, null:false
      t.char :codigo, limit: 3, null:false
      t.varchar :nombre, limit: 50, null:false
      t.references :unidad, foreign_key: true
      t.money :preciomay
      t.money :preciodetal
      t.decimal :existenciamin, :precision => 18, :scale => 0
      t.decimal :existenciamax, :precision => 18, :scale => 0
      t.money :costo
      t.datetime :fechaultcompra
      t.float :porcentajeIva
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE articulos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE articulos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :articulos
  end
end
