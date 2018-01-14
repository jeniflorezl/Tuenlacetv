class CreatePlanes < ActiveRecord::Migration[5.1]
  def up
    create_table :planes do |t|
      t.references :servicio, foreign_key: true
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE planes
      ADD CONSTRAINT DF_planes_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE planes
      ADD CONSTRAINT DF_planes_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE planes
      DROP CONSTRAINT DF_planes_fechacre
    ALTER TABLE planes
      DROP CONSTRAINT DF_planes_fechacam
    SQL
    drop_table :planes
  end
end
