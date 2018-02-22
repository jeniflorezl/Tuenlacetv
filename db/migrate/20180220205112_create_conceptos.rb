class CreateConceptos < ActiveRecord::Migration[5.1]
  def up
    create_table :conceptos do |t|
      t.references :servicio, foreign_key: true, null:false
      t.char :codigo, limit: 3, null:false
      t.varchar :nombre, limit: 20, null:false
      t.char :abreviatura, limit: 3, null:false
      t.float :porcentajeIva, null:false
      t.char :operacion, limit: 1, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE conceptos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE conceptos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :conceptos
  end
end
