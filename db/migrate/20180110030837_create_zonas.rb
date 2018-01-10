class CreateZonas < ActiveRecord::Migration[5.1]
  def up
    create_table :zonas do |t|
      t.references :ciudad, foreign_key: true
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE zonas
      ADD CONSTRAINT DF_zonas_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE zonas
      ADD CONSTRAINT DF_zonas_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE zonas
      DROP CONSTRAINT DF_zonas_fechacre
    ALTER TABLE zonas
      DROP CONSTRAINT DF_zonas_fechacam
    SQL
    drop_table :zonas
  end
end
