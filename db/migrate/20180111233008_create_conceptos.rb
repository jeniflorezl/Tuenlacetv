class CreateConceptos < ActiveRecord::Migration[5.1]
  def up
    create_table :conceptos do |t|
      t.references :servicio, foreign_key: true
      t.char :codigo, limit: 3, null:false
      t.varchar :nombre, limit: 20, null:false
      t.float :porcentajeIva, null:false
      t.varchar :tipoDocumento, limit: 20, null:false
      t.varchar :abreviatura, limit: 20, null:false
      t.char :operacion, limit: 1, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE conceptos
      ADD CONSTRAINT DF_conceptos_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE conceptos
      ADD CONSTRAINT DF_conceptos_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE conceptos
      DROP CONSTRAINT DF_conceptos_fechacre
    ALTER TABLE conceptos
      DROP CONSTRAINT DF_conceptos_fechacam
    SQL
    drop_table :conceptos
  end
end
