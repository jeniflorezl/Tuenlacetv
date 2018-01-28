class CreateEntidades < ActiveRecord::Migration[5.1]
  def up
    create_table :entidades do |t|
      t.references :funcion, foreign_key: true
      t.references :persona, foreign_key: true
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE entidades
      ADD CONSTRAINT DF_entidades_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE entidades
      ADD CONSTRAINT DF_entidades_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE entidades
      DROP CONSTRAINT DF_entidades_fechacre
    ALTER TABLE entidades
      DROP CONSTRAINT DF_entidades_fechacam
    SQL
    drop_table :entidades
  end
end
