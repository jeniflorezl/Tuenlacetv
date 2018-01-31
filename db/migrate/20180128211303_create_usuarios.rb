class CreateUsuarios < ActiveRecord::Migration[5.1]
  def up
    create_table :usuarios do |t|
      t.varchar :login, limit: 10, null:false
      t.varchar :nombre, limit: 50, null:false
      t.varchar :clave, limit: 15, null:false
      t.char :nivel, limit: 1, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE usuarios
      ADD CONSTRAINT DF_usuarios_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE usuarios
      ADD CONSTRAINT DF_usuarios_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE usuarios
      DROP CONSTRAINT DF_usuarios_fechacre
    ALTER TABLE usuarios
      DROP CONSTRAINT DF_usuarios_fechacam
    SQL
    drop_table :usuarios
  end
end
