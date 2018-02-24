class CreateArticulos < ActiveRecord::Migration[5.1]
  def up
    create_table :articulos do |t|
      t.references :grupo, foreign_key: true, null:false
      t.char :codigo, limit: 3, null:false
      t.varchar :nombre, limit: 20, null:false
      t.references :unidad, foreign_key: true, null:false
      t.money :preciomay
      t.money :preciodetal
      t.decimal :existenciamin, :precision => 18, :scale => 0, null:false
      t.decimal :existenciamax, :precision => 18, :scale => 0, null:false
      t.money :costo, null:false
      t.datetime :fechaultcompra
      t.float :porcentajeIva, null:false
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