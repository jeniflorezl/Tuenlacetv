class CreateFunciones < ActiveRecord::Migration[5.1]
  def up
    create_table :funciones do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE funciones
      ADD CONSTRAINT DF_funciones_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE funciones
      ADD CONSTRAINT DF_funciones_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE funciones
      DROP CONSTRAINT DF_funciones_fechacre
    ALTER TABLE funciones
      DROP CONSTRAINT DF_funciones_fechacam
    SQL
    drop_table :funciones
  end
end
