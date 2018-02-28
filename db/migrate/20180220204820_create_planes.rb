class CreatePlanes < ActiveRecord::Migration[5.1]
  def up
    create_table :planes do |t|
      t.references :servicio, foreign_key: true, null:false
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE planes 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE planes 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :planes
  end
end
